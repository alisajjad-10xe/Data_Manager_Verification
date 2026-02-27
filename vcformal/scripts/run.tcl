if {[info exists env(DUT_TOP)]} {
    puts "DUT_TOP is available: $env(DUT_TOP)"
} else {
    error "Error: Environment variable DUT_TOP is not set. Please define it before running the script."
}

if {[info exists env(FPV_PATH)]} {
    puts "FPV_PATH is available: $env(FPV_PATH)"
} else {
    error "Error: Environment variable FPV_PATH is not set. Please define it before running the script."
}
set design_top        $env(DUT_TOP)
set lab_path          $env(FPV_PATH)
set_fml_appmode FPV
set_app_var fml_auto_save true
set_fml_var fml_witness_on true
set_fml_var fml_vacuity_on true
# Add the host file
set_grid_usage -file ${lab_path}/scripts/host.bsub

########################################################
## Compile & Setup
########################################################
# Compilation Step 
read_file -top $design_top -format sverilog -sva \
  -vcs "-f ${lab_path}/rtl/filelist \
   ${lab_path}/sva/data_manager.sva ${lab_path}/sva/data_manager_bind.sva"

create_clock clk -period 100  
create_reset reset -sense high 

# Generate reset state
sim_run -stable
sim_save_reset
fvlearn_config -local_dir learn_data_manager

# fvtask prop_task -create -copy FPV -asserts * -assumes *
# -attributes {{fml_max_time 1H} {fml_witness_on true}}
# check_fv -block
# report_fv -list
