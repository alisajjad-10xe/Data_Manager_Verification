#!/bin/csh

# Load required tools
module load vcs verdi
module load vcstatic/2024.09-SP2-4

# Set FPV_PATH to current working directory
setenv FPV_PATH `pwd`

# Run make with DUT_TOP and FPV_PATH
if ("$1" == "vcf_restore") then
    if ("$2" == "") then
        echo "Error: Missing session name for vcf_restore"
        exit 1
    endif
    make DUT_TOP=data_manager FPV_PATH=$FPV_PATH vcf_restore SESSION=$2
else
    # Default case: pass arguments to make
    make DUT_TOP=data_manager FPV_PATH=$FPV_PATH $1
endif