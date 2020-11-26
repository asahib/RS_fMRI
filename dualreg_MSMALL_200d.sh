#!/bin/bash
#SBATCH --job-name=dualreg
#SBATCH --output=/nafs/narr/mvasavada/gica_baselineKs-HC_113018/gica_121218_k01S01Hs_d100/
#
#SBATCH --ntasks=1
#SBATCH --time=96:00:00
#SBATCH --mem-per-cpu=20G


module load fsl/6.0.1
export FSL_MEM=500
#srun dual_regression /nafs/narr/mvasavada/gica_baselineKs-HC_113018/gica_121218_k01S01Hs_d100/melodic_IC.nii.gz 1 -1 0 /nafs/narr/mvasavada/gi:ca_baselineKs-HC_113018/gica_121218_k01S01Hs_d100/KsTP3-HCs_121218_AP.dr `cat /nafs/narr/mvasavada/gica_baselineKs-HC_113018/KsTP3HCs01_AP.txt`

dual_regression /nafs/narr/asahib/MR_fix_MSMALL_GICA/rs_fmri200d/output_200d/melodic200IC.nii.gz 1 -1 0 /nafs/narr/asahib/MR_fix_MSMALL_GICA/rs_fmri200d/dualreg_200d/Extra_ECT/dr_ECT.dr `cat /nafs/narr/asahib/MR_fix_MSMALL_GICA/rs_fmri200d/dualreg_200d/Extra_ECT/dualreg_ECT.txt`
