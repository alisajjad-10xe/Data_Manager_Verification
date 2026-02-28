
clear -all

global env


set design_top        $env(DUT_TOP)
set lab_path          $env(FPV_PATH)

analyze -sv09 $lab_path/rtl/data_manager.sv

analyze -sv09 $lab_path/bind/data_manager_bind.sv $lab_path/sva/data_manager_sva.sv

elaborate  -top data_manager -disable_auto_bbox -create_related_covers {precondition witness}

clock clk
reset reset

get_design_info

set_engine_mode auto

set_proofgrid_manager on

##prove -bg -all
