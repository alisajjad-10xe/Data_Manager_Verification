#----------------------------------------
# JasperGold Version Info
# tool      : JasperGold 2019.06
# platform  : Linux 3.10.0-1160.118.1.el7.x86_64
# version   : 2019.06 FCS 64 bits
# build date: 2019.06.29 18:06:18 PDT
#----------------------------------------
# started Tue Feb 24 21:28:16 PKT 2026
# hostname  : localhost.localdomain
# pid       : 7120
# arguments : '-label' 'session_0' '-console' 'localhost.localdomain:41962' '-style' 'windows' '-data' 'AQAAADx/////AAAAAAAAA3oBAAAAEABMAE0AUgBFAE0ATwBWAEU=' '-proj' '/home/ali_sajjad/Desktop/fpv_db/data_manager/jgproject/sessionLogs/session_0' '-init' '-hidden' '/home/ali_sajjad/Desktop/fpv_db/data_manager/jgproject/.tmp/.initCmds.tcl' '/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl'

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
prove -bg -all
visualize -violation -property <embedded>::data_manager.u_data_manager_sva.ast_stable_when_not_ready -new_window
visualize -violation -property <embedded>::data_manager.u_data_manager_sva.ast_stable_when_not_ready -new_window
check_reset
get_reset_info
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
visualize -violation -property <embedded>::data_manager.u_data_manager_sva.ast_stable_when_not_ready -new_window
visualize -violation -property <embedded>::data_manager.u_data_manager_sva.ast_stable_when_not_ready -new_window
visualize -property <embedded>::data_manager.u_data_manager_sva.asm_abort_data_matches_sent:witness1 -new_window
visualize -property <embedded>::data_manager.u_data_manager_sva.ast_stable_when_not_ready:witness1 -new_window
