#!/bin/bash
#SBATCH --job-name=melodic_gICA
#SBATCH --output=/nafs/narr/mvasavada/gica_Ks01-HC_120518/
#
#SBATCH --ntasks=1
#SBATCH --time=96:00:00
#SBATCH --mem-per-cpu=20G


module load fsl/6.0.1
export FSL_MEM=600

/nafs/apps/fsl/64/6.0.1/bin/melodic -i CIFTI_subs.txt -o output_200d/ --nobet -a concat -v --Oall --CIFTI -d 200 --report
#srun melodic -i /nafs/narr/asahib/GICA/SUBJECTS.txt -o /nafs/narr/asahib/output_200d --nobet --nomask --bgthreshold=1  -a concat --report --Oall -v -d 200
