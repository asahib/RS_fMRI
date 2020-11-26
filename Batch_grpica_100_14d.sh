#!/bin/bash

#/ifshome/ewood/code/SFARI_RS/generate_jobs.sh
#fairshare
#http://cdoc.bmap.ucla.edu/compute/quickstart.html
#rsync -avz --exclude 'Analysis_JL/DATA'  Analysis_JL/*  cl.bmap.ucla.edu:/nafs/narr/jloureiro/
#rsync -avz --exclude 'Analysis_JL/DATA'  Analysis_JL/scripts/*  cl.bmap.ucla.edu:/nafs/narr/jloureiro/scripts/
maindir="/nafs/narr/asahib/MR_fix_MSMALL_GICA/rs_fmri100d"
#Subjlist=$(<$maindir/logstxt/SubsALL.txt) #Space delimited list of subject IDs
#Subjlist="k000801"

#hcpdir="/nafs/narr/HCP_OUTPUT"

 
    echo "sbatch --nodes=1 --ntasks=1 --cpus-per-task=7 --qos=largemem --mem=100G --time=7-00:00:00 \
--job-name=100_d_ica --output=/nafs/narr/asahib/MR_fix_MSMALL_GICA/rs_fmri100d/gica_100_14d.log /nafs/narr/asahib/MR_fix_MSMALL_GICA/rs_fmri100d/GICA_MSMALL_100d.sh"
    sbatch --nodes=1 --ntasks=1 --cpus-per-task=7 --mem=80G --time=5-00:00:00 \
--job-name=100_d_ica --output=/nafs/narr/asahib/MR_fix_MSMALL_GICA/rs_fmri100d/gica_100_14d.log /nafs/narr/asahib/MR_fix_MSMALL_GICA/rs_fmri100d/GICA_MSMALL_100d.sh
#--job-name=gica_50d --output=/nafs/narr/asahib/GICA/gica_50d.log /nafs/narr/asahib/GICA/GICA_3.sh

#{line} --output=/nafs/narr/jloureiro/projects/FM_taskfMRI/FM_taskfMRI_${line}.log --export BATCH_SUB=${line} /nafs/narr/jloureiro/scripts/Pipelines-3.22.0/TaskfMRIAnalysis/scripts/TaskfMRIAnalysisBatch_JL_20cons_PA1st_4slurm.v1.0.sh

	#sbatch --nodes=1 --ntasks=1 --cpus-per-task=2 --mem=20G --time=2-00:00:00 \
#--job-name=FM_taskfMRI_wFIX_${line} --output=/nafs/narr/jloureiro/projects/FM_taskfMRI_wFIX/FM_taskfMRI_wFIX_${line}.log --export BATCH_SUB=${line} /nafs/narr/jloureiro/scripts/Pipelines-3.22.0/TaskfMRIAnalysis/scripts/TaskfMRIAnalysisBatch_JL_20cons_4slurm_wFIX.0.sh

	#sbatch --nodes=1 --ntasks=1 --cpus-per-task=2 --mem=20G --time=2-00:00:00 \
#--job-name=FM_taskfMRI_wFIX_${line} --output=/nafs/narr/jloureiro/projects/FM_taskfMRI_parcellate/FM_taskfMRI_parcellate_${line}.log --export BATCH_SUB=${line} /nafs/narr/jloureiro/scripts/Pipelines-3.22.0/TaskfMRIAnalysis/scripts/TaskfMRIAnalysisBatch_JL_20cons_4slurm.v1.0.sh


