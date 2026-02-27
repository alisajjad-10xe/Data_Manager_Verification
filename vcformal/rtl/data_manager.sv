module data_manager #(
    parameter int DEPTH      = 48,    // Total outstanding entries allowed
    parameter int DATA_WIDTH = 32     // Width of data_o and abort_data
)(
    input  logic                    clk,
    input  logic                    reset,

    // Valid/Ready Handshake & Data Out
    output logic                    valid_o,
    input  logic                    ready_i,
    output logic [DATA_WIDTH-1:0]   data_o,
    output logic [$clog2(DEPTH)-1:0] data_id,

    // Abort/Retire interface
    input  logic                    abort_vld,
    input  logic [$clog2(DEPTH)-1:0] abort_id,
    input  logic [$clog2(DEPTH)-1:0] retire_ptr,
    input  logic [DATA_WIDTH-1:0]   abort_data
);

    // ------------------------------------------------------------------------
    // Derived Localparams
    // ------------------------------------------------------------------------
    localparam int PTR_W = $clog2(DEPTH);
    // Counter needs an extra bit to represent the value "DEPTH" (e.g., 48)
    localparam int CNT_W = $clog2(DEPTH + 1);

    // ------------------------------------------------------------------------
    // Internal State
    // ------------------------------------------------------------------------
    logic [DATA_WIDTH-1:0] internal_buffer [0:DEPTH-1];

    logic [PTR_W-1:0]  send_ptr;
    logic [PTR_W-1:0]  retire_ptr_q;
    logic [CNT_W-1:0]  outstanding_cnt;
    logic [DATA_WIDTH-1:0] current_data;

    // ------------------------------------------------------------------------
    // Logic Signals
    // ------------------------------------------------------------------------
    logic             send_fire;
    logic [CNT_W-1:0] retire_diff;

    assign valid_o   = (outstanding_cnt < DEPTH);
    assign send_fire = valid_o && ready_i;
    assign data_o    = current_data;
    assign data_id   = send_ptr;

    // Helper function for circular distance
    function automatic logic [CNT_W-1:0] calc_distance(
        input logic [PTR_W-1:0] head, 
        input logic [PTR_W-1:0] tail
    );
        if (head >= tail) begin
            calc_distance = head - tail;
        end else begin
            // Cast DEPTH to ensure the addition doesn't truncate
            calc_distance = (CNT_W'(head) + CNT_W'(DEPTH)) - CNT_W'(tail);
        end
    endfunction

    assign retire_diff = calc_distance(retire_ptr, retire_ptr_q);

    // ------------------------------------------------------------------------
    // Buffer & Control Logic
    // ------------------------------------------------------------------------
    always_ff @(posedge clk) begin
        if (send_fire && !abort_vld) begin
            internal_buffer[send_ptr] <= current_data;
        end
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            send_ptr        <= '0;
            retire_ptr_q    <= '0;
            outstanding_cnt <= '0;
            current_data    <= '0;
        end else begin
            retire_ptr_q <= retire_ptr;

            if (abort_vld) begin
                send_ptr        <= abort_id;
                current_data    <= abort_data;
                outstanding_cnt <= calc_distance(abort_id, retire_ptr);
            end else begin
                // Pointer increment with wrap-around check
                if (send_fire) begin
                    send_ptr     <= (send_ptr == PTR_W'(DEPTH - 1)) ? '0 : send_ptr + 1'b1;
                    current_data <= current_data + 1'b1;
                end
                
                // Update counter: +1 if sending, -N if retiring
                outstanding_cnt <= outstanding_cnt + (send_fire ? 1'b1 : '0) - retire_diff;
            end
        end
    end

endmodule