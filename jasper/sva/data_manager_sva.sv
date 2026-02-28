
module data_manager_sva
  #(parameter DEPTH      = 7, 
    parameter DATA_WIDTH = 32 
)
   (
        input  logic                    clk,
        input  logic                    reset,

        // Valid/Ready Handshake & Data Out
        input  logic                    valid_o,
        input  logic                    ready_i,
        input  logic [DATA_WIDTH-1:0]   data_o,
        input  logic [$clog2(DEPTH)-1:0] data_id,

        // Abort/Retire interface
        input  logic                    abort_vld,
        input  logic [$clog2(DEPTH)-1:0] abort_id,
        input  logic [$clog2(DEPTH)-1:0] retire_ptr,
        input  logic [DATA_WIDTH-1:0]   abort_data,
        // Used in assertion to check reference outstanding count correctness
        input logic [$clog2(DEPTH + 1)-1:0] outstanding_cnt
    );

    // Default clocking block
    default clocking @(posedge clk); endclocking
    // Default disable iff
    default disable iff (reset);
    
    // --------------------------------
    // Aux Code
    // --------------------------------
    logic [DEPTH-1:0] ref_out_buf;
    logic [$clog2(DEPTH+1)-1:0] ref_out_cnt;
    logic [$clog2(DEPTH)-1:0]  retire_ptr_prev;
    logic data_hsk;
    logic [$clog2(DEPTH)-1:0] min_ptr, max_ptr, next_min_ptr, next_max_ptr;
    logic abort_id_in_range, next_abort_id_in_range;
    logic [$clog2(DEPTH+1)-1:0] retire_jump;
    logic [$clog2(DEPTH+1)-1:0] abort_id_diff;
    logic [DATA_WIDTH-1:0] sent_data [0:DEPTH-1];
    localparam int PTR_W = $clog2(DEPTH);
    localparam int CNT_W = $clog2(DEPTH + 1);

    // Helper functions
    function automatic logic [CNT_W-1:0] calc_distance(
        input logic [PTR_W-1:0] head, 
        input logic [PTR_W-1:0] tail
    );
        if (head >= tail) begin
            calc_distance = head - tail;
        end else begin
            calc_distance = (CNT_W'(head) + CNT_W'(DEPTH)) - CNT_W'(tail);
        end
    endfunction

    function automatic logic is_in_circular_range(
        input logic [PTR_W-1:0] id,
        input logic [PTR_W-1:0] head, 
        input logic [PTR_W-1:0] tail
    );
        if (head <= tail) begin
            return (id >= head && id < tail);
        end else begin
            return (id >= head || id < tail);
        end
    endfunction

    function automatic logic is_younger_id(
        input logic [PTR_W-1:0] i,
        input logic [PTR_W-1:0] abort_id,
        input logic [DEPTH-1:0] outstanding_mask,
        input logic [PTR_W-1:0] retire_ptr
    );
    // An ID is younger if it is outstanding AND its distance 
    // from the retire_ptr is greater than the abort_id's distance.
    return (outstanding_mask[i] && 
           (calc_distance(i, retire_ptr) >= calc_distance(abort_id, retire_ptr)));
    endfunction

    assign data_hsk = valid_o && ready_i;
    
    always_ff @(posedge clk) begin
        if (data_hsk && !abort_vld) begin
            sent_data[data_id] <= data_o;
        end
    end

    // Modeling Outstanding Entries
    always_ff @(posedge clk) begin
        if (reset) begin
            ref_out_buf      <= '0;
            retire_ptr_prev  <= '0;
        end else begin
            retire_ptr_prev <= retire_ptr;

            // 1. Handle Retire
            for (int i = 0; i < DEPTH; i++) begin
                if (is_in_circular_range(i[PTR_W-1:0], retire_ptr_prev, retire_ptr)) begin
                    ref_out_buf[i] <= 1'b0;
                end
            end

            if (abort_vld) begin
                // 2. Handle Abort (Spec 6)
                for (int i = 0; i < DEPTH; i++) begin
                    if (is_younger_id(i[PTR_W-1:0], abort_id, ref_out_buf, retire_ptr)) begin
                        ref_out_buf[i] <= 1'b0;
                    end
                end
            end else if (data_hsk) begin
                // 3. Handle Handshake
                ref_out_buf[data_id] <= 1'b1;
            end
        end
    end


    assign retire_jump = calc_distance(retire_ptr, retire_ptr_prev);
    assign abort_id_diff = calc_distance(abort_id, retire_ptr);
    assign ref_out_cnt = $countones(ref_out_buf);

    // --------------------------------
    // Assumptions
    // --------------------------------

    asm_ready_i_stable: assume property (valid_o && !ready_i |=> !$isunknown($past(ready_i)));
    asm_no_abort_when_no_ready: assume property (valid_o && !ready_i |=> !abort_vld);
    asm_retire_ptr_bound: assume property (retire_ptr < DEPTH && retire_ptr >= 0);
    asm_abort_id_bound: assume property (abort_id < DEPTH && abort_id >= 0);

    asm_max_retire_ptr_jump: assume property (retire_jump <= 6  && retire_jump >= 0);
    asm_abort_and_retire_no_simultaneous: assume property (abort_vld |-> (retire_jump == 0));
    asm_abort_id_legal: assume property (abort_vld |-> (ref_out_cnt > 0) ? (abort_id_diff < ref_out_cnt) : (abort_id == retire_ptr));
    asm_retire_ptr_range: assume property ((retire_ptr != retire_ptr_prev) |-> (ref_out_cnt > 0) && (retire_jump <= ref_out_cnt));
    asm_abort_data_matches_sent: assume property (abort_vld && ref_out_buf[abort_id] |-> (abort_data == sent_data[abort_id]));

    // --------------------------------
    // Assertions
    // --------------------------------

    ast_stable_when_not_ready: assert property ( valid_o && !ready_i && !abort_vld |=> valid_o && ($stable(data_o) && $stable(data_id)));
    ast_id_increment: assert property (data_hsk && !abort_vld |=> (data_id == (($past(data_id)==DEPTH-1) ? '0 : $past(data_id)+1)));
    ast_ref_outstanding_cnt_correct: assert property (!abort_vld |=> outstanding_cnt == ref_out_cnt);
    ast_full_depth_outstanding: assert property ((ref_out_cnt == DEPTH) |-> !valid_o);
    ast_outstanding_cnt_limit: assert property (ref_out_cnt <= DEPTH);
    ast_abort_update_data_id: assert property (abort_vld |=> (data_id == $past(abort_id)) && (data_o == $past(abort_data)));
    ast_cnt_update_logic: assert property (!abort_vld |=> ref_out_cnt == ($past(ref_out_cnt) + $past(data_hsk) - $past(retire_jump)));
    
    // Data Integrity Checks
    ast_buffer_write: assert property (data_hsk && !abort_vld |=> (sent_data[$past(data_id)] == $past(data_o)));
    generate
        for (genvar i = 0; i < DEPTH; i++) begin : gen_buf_checks
            ast_buffer_stability: assert property (
                ((calc_distance(i, retire_ptr) < ref_out_cnt) && !data_hsk && !abort_vld && data_id == i)
                |=> $stable(sent_data[i]));
        end
    endgenerate

    // --------------------------------
    // Covers
    // --------------------------------
    cover_data_ids_wrap: cover property (data_id == 0 ##(DEPTH-1) data_id == DEPTH-1 ##1 data_id == 0);


endmodule