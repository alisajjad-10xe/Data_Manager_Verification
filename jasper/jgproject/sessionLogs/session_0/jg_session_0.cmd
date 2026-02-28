#----------------------------------------
# JasperGold Version Info
# tool      : JasperGold 2019.06
# platform  : Linux 3.10.0-1160.118.1.el7.x86_64
# version   : 2019.06 FCS 64 bits
# build date: 2019.06.29 18:06:18 PDT
#----------------------------------------
# started Fri Feb 27 23:29:32 PKT 2026
# hostname  : localhost.localdomain
# pid       : 34441
# arguments : '-label' 'session_0' '-console' 'localhost.localdomain:43792' '-style' 'windows' '-data' 'AQAAADx/////AAAAAAAAA3oBAAAAEABMAE0AUgBFAE0ATwBWAEU=' '-proj' '/home/ali_sajjad/Desktop/fpv_db/data_manager/jgproject/sessionLogs/session_0' '-init' '-hidden' '/home/ali_sajjad/Desktop/fpv_db/data_manager/jgproject/.tmp/.initCmds.tcl' '/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl'

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
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
visualize -violation -property <embedded>::data_manager.u_data_manager_sva.ast_stable_when_not_ready -new_window
visualize -violation -property <embedded>::data_manager.u_data_manager_sva.ast_cnt_update_logic -new_window
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
visualize -violation -property <embedded>::data_manager.u_data_manager_sva.ast_ref_outstanding_cnt_correct -new_window
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
visualize -violation -property <embedded>::data_manager.u_data_manager_sva.ast_ref_outstanding_cnt_correct -new_window
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
visualize -violation -property <embedded>::data_manager.u_data_manager_sva.ast_ref_outstanding_cnt_correct -new_window
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
visualize -violation -property <embedded>::data_manager.u_data_manager_sva.ast_ref_outstanding_cnt_correct -new_window
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
visualize -violation -property <embedded>::data_manager.u_data_manager_sva.ast_ref_outstanding_cnt_correct -new_window
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
visualize -violation -property <embedded>::data_manager.u_data_manager_sva.ast_ref_outstanding_cnt_correct -new_window
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
visualize -violation -property <embedded>::data_manager.u_data_manager_sva.ast_ref_outstanding_cnt_correct -new_window
visualize -violation -property <embedded>::data_manager.u_data_manager_sva.ast_ref_outstanding_cnt_correct -new_window
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
visualize -violation -property <embedded>::data_manager.u_data_manager_sva.ast_outstanding_cnt_limit -new_window
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
visualize -property <embedded>::data_manager.u_data_manager_sva.cover_data_ids_wrap -new_window
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
visualize -violation -property <embedded>::data_manager.u_data_manager_sva.ast_buffer_write -new_window
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
visualize -violation -property <embedded>::data_manager.u_data_manager_sva.ast_buffer_write -new_window
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
visualize -violation -property {<embedded>::data_manager.u_data_manager_sva.gen_buf_checks[0].ast_buffer_stability} -new_window
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
visualize -property {<embedded>::data_manager.u_data_manager_sva.gen_buf_checks[0].ast_buffer_stability:precondition1} -new_window
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
visualize -violation -property <embedded>::data_manager.u_data_manager_sva.ast_ref_outstanding_cnt_correct -new_window
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
include {/home/ali_sajjad/Desktop/fpv_db/data_manager/scripts/jg.tcl}
prove -bg -all
