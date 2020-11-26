#!/bin/bash
maindir="/nafs/narr/canderson/new_pipeline_test_runs/out2"
hcpdir="/nafs/narr/HCP_OUTPUT"
txtfile="/nafs/narr/asahib/MR_fix_MSMALL_GICA"


module unload fsl
module load fsl/6.0.1
module unload workbench
module load workbench/1.3.2
cd ${maindir}


#ALLSubjects=$(<$txtfile/sublist.txt)

#for sub in $ALLSubjects
	#do
		for session in AP PA ; do
			if [ $session == "AP" ]; then
				dseries="${maindir}/${sub}/MNINonLinear/Results/rest_acq-${session}_run-01/rest_acq-${session}_run-01_Atlas_MSMAll_Test_hp2000_clean.dtseries.nii"
				Subcor="${maindir}/${sub}/MNINonLinear/Results/rest_acq-${session}_run-01/subcortical_MSMALL.${session}.nii.gz"
				left_cortex="${maindir}/${sub}/MNINonLinear/Results/rest_acq-${session}_run-01/left_MSMALL.${session}_run-01.func.gii"
				right_cortex="${maindir}/${sub}/MNINonLinear/Results/rest_acq-${session}_run-01/right_MSMALL.${session}_run-01.func.gii"
				wb_command -cifti-separate $dseries COLUMN -volume-all $Subcor -metric CORTEX_LEFT $left_cortex -metric CORTEX_RIGHT $right_cortex
				
				left_vol="${maindir}/${sub}/MNINonLinear/Results/rest_acq-${session}_run-01/MSMALL.left.${session}_run-01.nii.gz"
				right_vol="${maindir}/${sub}/MNINonLinear/Results/rest_acq-${session}_run-01/MSMALL.right.${session}_run-01.nii.gz"
				MNI_template="/nafs/narr/asahib/S1200_ATLAS/MNI152_T1_2mm.nii.gz"
				
				surface_l="${maindir}/${sub}/MNINonLinear/fsaverage_LR32k/${sub}.L.midthickness_MSMAll_Test.32k_fs_LR.surf.gii"
				surface_r="${maindir}/${sub}/MNINonLinear/fsaverage_LR32k/${sub}.R.midthickness_MSMAll_Test.32k_fs_LR.surf.gii"
				ribboninner_l="${maindir}/${sub}/MNINonLinear/fsaverage_LR32k/${sub}.L.white_MSMAll_Test.32k_fs_LR.surf.gii"
				ribboninner_r="${maindir}/${sub}/MNINonLinear/fsaverage_LR32k/${sub}.R.white_MSMAll_Test.32k_fs_LR.surf.gii"
				ribbonouter_l="${maindir}/${sub}/MNINonLinear/fsaverage_LR32k/${sub}.L.pial_MSMAll_Test.32k_fs_LR.surf.gii"
				ribbonouter_r="${maindir}/${sub}/MNINonLinear/fsaverage_LR32k/${sub}.R.pial_MSMAll_Test.32k_fs_LR.surf.gii"
				wb_command -metric-to-volume-mapping $left_cortex $surface_l $MNI_template $left_vol -ribbon-constrained $ribboninner_l $ribbonouter_l
				wb_command -metric-to-volume-mapping $right_cortex $surface_r $MNI_template $right_vol -ribbon-constrained $ribboninner_r $ribbonouter_r

				ouptput_vol="${maindir}/${sub}/MNINonLinear/Results/rest_acq-${session}_run-01/${sub}.${session}_MSMALL_run-01.volume.nii.gz"
				wb_command -volume-math x+y+z $ouptput_vol -var x $left_vol -var y $right_vol -var z $Subcor
				
			else
				dseries="${maindir}/${sub}/MNINonLinear/Results/rest_acq-${session}_run-02/rest_acq-${session}_run-02_Atlas_MSMAll_Test_hp2000_clean.dtseries.nii"
				Subcor="${maindir}/${sub}/MNINonLinear/Results/rest_acq-${session}_run-02/subcortical_MSMALL.${session}_run-02.nii.gz"
				left_cortex="${maindir}/${sub}/MNINonLinear/Results/rest_acq-${session}_run-02/left_MSMALL.${session}_run-02.func.gii"
				right_cortex="${maindir}/${sub}/MNINonLinear/Results/rest_acq-${session}_run-02/right_MSMALL.${session}_run-02.func.gii"
				wb_command -cifti-separate $dseries COLUMN -volume-all $Subcor -metric CORTEX_LEFT $left_cortex -metric CORTEX_RIGHT $right_cortex
				
				left_vol="${maindir}/${sub}/MNINonLinear/Results/rest_acq-${session}_run-02/MSMALL.left.${session}_run-02.nii.gz"
				right_vol="${maindir}/${sub}/MNINonLinear/Results/rest_acq-${session}_run-02/MSMALL.right.${session}_run-02.nii.gz"
				MNI_template="/nafs/narr/asahib/S1200_ATLAS/MNI152_T1_2mm.nii.gz"
		
				surface_l="${maindir}/${sub}/MNINonLinear/fsaverage_LR32k/${sub}.L.midthickness_MSMAll_Test.32k_fs_LR.surf.gii"
				surface_r="${maindir}/${sub}/MNINonLinear/fsaverage_LR32k/${sub}.R.midthickness_MSMAll_Test.32k_fs_LR.surf.gii"
				ribboninner_l="${maindir}/${sub}/MNINonLinear/fsaverage_LR32k/${sub}.L.white_MSMAll_Test.32k_fs_LR.surf.gii"
				ribboninner_r="${maindir}/${sub}/MNINonLinear/fsaverage_LR32k/${sub}.R.white_MSMAll_Test.32k_fs_LR.surf.gii"
				ribbonouter_l="${maindir}/${sub}/MNINonLinear/fsaverage_LR32k/${sub}.L.pial_MSMAll_Test.32k_fs_LR.surf.gii"
				ribbonouter_r="${maindir}/${sub}/MNINonLinear/fsaverage_LR32k/${sub}.R.pial_MSMAll_Test.32k_fs_LR.surf.gii"
				wb_command -metric-to-volume-mapping $left_cortex $surface_l $MNI_template $left_vol -ribbon-constrained $ribboninner_l $ribbonouter_l
				wb_command -metric-to-volume-mapping $right_cortex $surface_r $MNI_template $right_vol -ribbon-constrained $ribboninner_r $ribbonouter_r

				ouptput_vol="${maindir}/${sub}/MNINonLinear/Results/rest_acq-${session}_run-02/${sub}.${session}_MSMALL_run-02.volume.nii.gz"
				wb_command -volume-math x+y+z $ouptput_vol -var x $left_vol -var y $right_vol -var z $Subcor
			fi
		done

	
#done
			













