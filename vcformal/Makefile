DUT_TOP="default"
FPV_PATH="default"

FPV_PATH=$(FPV_PATH)

# VCFORMAL
##################

vcf:
	cd dump
	vcf -f $(FPV_PATH)/scripts/run.tcl -fml_token -verdi

vcf_restore:
	vcf -session $(SESSION) -restore -verdi

clean:
	rm -rf vcst_* *.bak verdiLog *.log* *.fsdb* *_learn_dir