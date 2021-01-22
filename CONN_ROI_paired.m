
% CONN_BATCH_HUMANCONNECTOMEPROJECT batch processing script for the Human Connectome Project resting-state dataset (HCP; http://www.humanconnectome.org/; tested on Q6 497-subjects release)
% 
% This script assumes that the dataset is already available in your system (set the CONNECTOMEpath variable in this script to the appropriate folder)
%
% The script will create a new conn_HCP project and:
%   Load the preprocessed "clean" ICA+FIX functional series (four sessions)
%   Apply structural segmentation, functional ART scrubbing, and functional smoothing
%   Apply default aCompCor denoising and band-pass filtering
%   Compute seed-to-voxel and ROI-to-ROI bivariate correlation connectivity measures for all CONN default ROIs (atlas + dmn)
%
% Default settings (see code for details):
%    Run each individual subject in a separate parallel stream (edit RUNPARALLEL and NJOBS variables in this script to modify these settings)
%    Assumes user has write permission into connectome data folders (edit COPYFILES variable in this script when users have only read-permissions)
%    Run all subjects in dataset (edit NSUBJECTS in this script to process instead only a subset of subjects)
%


% note: before running this script it is recommended to test it first with just a few subjects to make sure everything is working
% as expected. To do so, set NSUBJECTS=4; in the DEFAULT SETTINGS section of this script
%
%% DEFAULT SETTINGS: EDIT THE LINES BELOW (minimally set CONNECTOMEpath to the actual location of your connectome data)
addpath(genpath('/nafs/narr/HCP_OUTPUT/Habenula/conn'))
addpath('/nafs/apps/spm/64/12')

TARGETpath='/nafs/narr/asahib/MR_fix_MSMALL_GICA/CONN_analysis/ECT1_ECT2_27';                                                             % target folder for conn project (default current folder)
CONNECTOMEpath='/nafs/narr/canderson/new_pipeline_test_runs/out/%s/MNINonLinear';              % source of connectome dataset (%s stands for numeric subject-specific folders)
%subsdir='/nafs/narr/HCP_OUTPUT/Habenula/outputs/Segmentation/2_FinalHbROIs_ShapeOptimized/%s';
RUNPARALLEL=true;                                                           % run in parallel using computer cluster
NSUBJECTS=[];                                                               % number of subjects to include in your project (leave empty for all subjects)
NJOBS=[];                                                                   % number of parallel jobs to submit (leave empty for one job per subject)
COPYFILES=false;                                                            % true/false: set to true if you do not have write-permissions into connectome data folders
                                                                            %   This will create a local copy (in same folder as your conn project) of the structural/functional data
                                                                            %   where any post-processed files will also be stored.
OVERWRITE=true;                                                            % overwrites files if they exist in target folder (unzipped files and/or files in local-copy folder)
                                                                            %   Set to false if you have already unzipped / copied-to-local-folder your data and would like to skip this step

%% FINDS STRUCTURAL/FUNCTIONAL/REALIGNMENT FILES
clear FUNCTIONAL_FILE* REALIGNMENT_FILE* STRUCTURAL_FILE;
%subs=dir(regexprep(subsdir,'%s.*$','*')); 
%subs=subs([subs.isdir]>0);
%subs={subs.name};
%subs(cellfun('length',subs)<5) = [];
%subs(cellfun('length',subs)>7) = [];
%subs=subs(117:307);
%subs=subs(308:end);
%subs=subs(1:115);
file_x = fopen('ECT1_ECT2_27IDS.txt');
subs = textscan(file_x,'%s');
[P,Q]=size(subs{1,1});

if isempty(NSUBJECTS), NSUBJECTS=P/2; 
else subs=subs(1:NSUBJECTS);
end
if isempty(NJOBS), NJOBS=NSUBJECTS; end
NJOBS=min(NSUBJECTS,NJOBS);
P=P/2;
for n=1:P
    fprintf('Locating subject %s files\n',subs{1,1}{n,1});
    
    t1=fullfile(sprintf(CONNECTOMEpath,subs{1,1}{n,1}),'T1w_restore_brain.nii.gz');                                        % STRUCTURAL VOLUME
    f1=fullfile(sprintf(CONNECTOMEpath,subs{1,1}{n,1}),'Results','rest_acq-AP_run-01','rest_acq-AP_run-01_hp2000_clean.nii.gz');   % FUNCTIONAL VOLUME (1/4)
    f2=fullfile(sprintf(CONNECTOMEpath,subs{1,1}{n,1}),'Results','rest_acq-PA_run-02','rest_acq-PA_run-02_hp2000_clean.nii.gz'); % FUNCTIONAL VOLUME (2/4)
    f3=fullfile(sprintf(CONNECTOMEpath,subs{1,1}{n+P,1}),'Results','rest_acq-AP_run-01','rest_acq-AP_run-01_hp2000_clean.nii.gz');   % FUNCTIONAL VOLUME (1/4)
    f4=fullfile(sprintf(CONNECTOMEpath,subs{1,1}{n+P,1}),'Results','rest_acq-PA_run-02','rest_acq-PA_run-02_hp2000_clean.nii.gz');
    
    %     r1=fullfile(sprintf(CONNECTOMEpath,subs{1,1}{n,1}),'Results','rest_acq-AP_run-01','Movement_Regressors.txt');              % REALIGNMENT FILE (1/4)
%     r2=fullfile(sprintf(CONNECTOMEpath,subs{1,1}{n,1}),'Results','rest_acq-AP_run-01','Movement_Regressors.txt');              % REALIGNMENT FILE (2/4)
    if isempty(dir(t1)), error('file %s not found',t1); end
    if isempty(dir(f1)), error('file %s not found',f1); end
    if isempty(dir(f2)), error('file %s not found',f2); end
%     if isempty(dir(r1)), warning('file %s not found',r1); end
%     if isempty(dir(r2)), warning('file %s not found',r2); end
    
    if COPYFILES
        fprintf('Copying files to local folder\n');
        [ok,nill]=mkdir(TARGETpath,'LocalCopyDataFiles');
        [ok,nill]=mkdir(fullfile(TARGETpath,'LocalCopyDataFiles'),subs{n});
        t1b=fullfile(TARGETpath,'LocalCopyDataFiles',subs{1,1}{n,1},'structural.nii.gz');  if OVERWRITE||isempty(dir(t1b)), [ok,nill]=system(sprintf('cp ''%s'' ''%s''',t1,t1b)); end; t1=t1b;
        f1b=fullfile(TARGETpath,'LocalCopyDataFiles',subs{1,1}{n,1},'functional1.nii.gz'); if OVERWRITE||isempty(dir(f1b)), [ok,nill]=system(sprintf('cp ''%s'' ''%s''',f1,f1b)); end; f1=f1b;
        f2b=fullfile(TARGETpath,'LocalCopyDataFiles',subs{1,1}{n,1},'functional2.nii.gz'); if OVERWRITE||isempty(dir(f2b)), [ok,nill]=system(sprintf('cp ''%s'' ''%s''',f2,f2b)); end; f2=f2b;
        r1b=fullfile(TARGETpath,'LocalCopyDataFiles',subs{1,1}{n,1},'Movement1.txt'); if OVERWRITE||isempty(dir(r1b)), [ok,nill]=system(sprintf('cp ''%s'' ''%s''',r1,r1b)); end; r1=r1b;
        r2b=fullfile(TARGETpath,'LocalCopyDataFiles',subs{1,1}{n,1},'Movement2.txt'); if OVERWRITE||isempty(dir(r2b)), [ok,nill]=system(sprintf('cp ''%s'' ''%s''',r2,r2b)); end; r2=r2b;
    end
    fprintf('Unzipping files\n');
    if OVERWRITE||isempty(dir(regexprep(t1,'\.gz$',''))), gunzip(t1); end; t1=regexprep(t1,'\.gz$','');
%     if OVERWRITE||isempty(dir(regexprep(f1,'\.gz$',''))), gunzip(f1); end; f1=regexprep(f1,'\.gz$','');
%     if OVERWRITE||isempty(dir(regexprep(f2,'\.gz$',''))), gunzip(f2); end; f2=regexprep(f2,'\.gz$','');
%     r1b=regexprep(r1,'\.txt$','\.deg.txt'); if OVERWRITE||isempty(dir(r1b)), [ok,nill]=system(sprintf('cp ''%s'' ''%s''',r1,r1b)); end; r1=r1b; % note: angles in degrees
%     r2b=regexprep(r2,'\.txt$','\.deg.txt'); if OVERWRITE||isempty(dir(r2b)), [ok,nill]=system(sprintf('cp ''%s'' ''%s''',r2,r2b)); end; r2=r2b; 
   STRUCTURAL_FILE{n,1}=t1;
    FUNCTIONAL_FILE(n,1:4)={f1,f2,f3,f4};
%     REALIGNMENT_FILE(n,1:2)={r1,r2};
end
nsessions=4;
fprintf('%d subjects, %d sessions\n',NSUBJECTS,nsessions);



%% CREATES CONN BATCH STRUCTURE
clear batch;
batch.filename=fullfile(TARGETpath,'conn_ECT1_ECT2.mat');
if RUNPARALLEL
    batch.parallel.N=NJOBS;                             % number of parallel processing batch jobs
    batch.parallel.profile='Slurm';
end% note: use default parallel profile (defined in GUI Tools.GridSettings)

%conn_jobmanager
% CONN Setup                                           
batch.Setup.isnew=1;
batch.Setup.nsubjects=NSUBJECTS;
batch.Setup.RT=0.8;                                    % TR (seconds)
batch.Setup.outputfiles=[1,1,0];

batch.Setup.conditions.names={'Pre','Post'};                  % single condition (aggregate across all sessions)
for ncond=1,for nsub=1:NSUBJECTS,for nses=1:2,      batch.Setup.conditions.onsets{ncond}{nsub}{nses}=0; batch.Setup.conditions.durations{ncond}{nsub}{nses}=inf;end;end;end     % rest condition (all sessions)
for ncond=2,for nsub=1:NSUBJECTS,for nses=3:4,      batch.Setup.conditions.onsets{ncond}{nsub}{nses}=0; batch.Setup.conditions.durations{ncond}{nsub}{nses}=inf;end;end;end     % rest condition (all sessions)

for ncond=1,for nsub=1:NSUBJECTS,for nses=3:4,      batch.Setup.conditions.onsets{ncond}{nsub}{nses}=[]; batch.Setup.conditions.durations{ncond}{nsub}{nses}=[];end;end;end     % rest condition (all sessions)
for ncond=2,for nsub=1:NSUBJECTS,for nses=1:2,      batch.Setup.conditions.onsets{ncond}{nsub}{nses}=[]; batch.Setup.conditions.durations{ncond}{nsub}{nses}=[];end;end;end     % rest condition (all sessions)

batch.Setup.functionals=repmat({{}},[NSUBJECTS,nsessions]);     % Point to functional volumes for each subject/session
for nsub=1:NSUBJECTS,for nses=1:nsessions,                  batch.Setup.functionals{nsub}{nses}=FUNCTIONAL_FILE(nsub,nses);end; end 

batch.Setup.structurals=STRUCTURAL_FILE;                % Point to anatomical volumes for each subject

%batch.Setup.voxelresolution=2;                          % default 2mm isotropic voxels analysis space

%batch.Setup.covariates.names={'realignment'};
%batch.Setup.covariates.files{1}=repmat({{}},[NSUBJECTS,1]);      
%for nsub=1:NSUBJECTS,for nses=1:nsessions,                    batch.Setup.covariates.files{1}{nsub}{nses}=REALIGNMENT_FILE(nsub,nses);end; end 

batch.Setup.analyses=1;                             % seed-to-voxel and ROI-to-ROI pipelines
batch.Setup.overwrite=1;                            
batch.Setup.done=1;

%batch.Setup.preprocessing.steps={'structural_segment','functional_art','functional_smooth'};  % Run additional preprocessing steps: segmentation,ART,smoothing
%batch.Setup.preprocessing.fwhm=6;                       % smoothing fwhm (mm)
%conn_batch(batch);

%clear batch;
% CONN Denoising                                    
batch.Denoising.filter=[0.01, 0.10];                    % frequency filter (band-pass values, in Hz)
batch.Denoising.confounds.names={'White','CSF'};
batch.Denoising.confounds.dimensions={3,3};
batch.Denoising.detrending=0;
 batch.Denoising.done=1;                                 % use default denoising step (CompCor, motion regression, scrubbing, detrending)
batch.Denoising.overwrite='Yes';
% conn_batch(batch);
% batch.Setup.rois.names={'networks'};
% batch.Setup.rois.files{1}=fullfile(fileparts(which('conn')),'rois','networks.nii');
%clear batch;
% CONN Analysis     
% Default options (uses all ROIs in conn/rois/ as connectivity sources); see conn_batch for additional options 
batch.Analysis.analysis_number=1;
batch.Analysis.done=1;
batch.Analysis.type=1;  %% for ROI-ROI analysis
batch.Analysis.overwrite='Yes';

batch.Results.between_subjects.effect_names={'AllSubjects'};
batch.Results.between_subjects.contrast=1;
batch.Results.between_conditions.effect_names={'Pre','Post'};
batch.Results.between_conditions.contrast=[1,-1];
batch.Results.done=1;
batch.Results.overwrite='Yes';
%% RUNS CONN BATCH STRUCTURE
conn_batch(batch);
