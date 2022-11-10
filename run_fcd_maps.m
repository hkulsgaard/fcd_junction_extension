clear;clc;tic;

%------------------------
%CONFIGURATION PARAMETERS
%------------------------
kernel_conv = 5; %default: 5
kernel_smoothing = 6; %default: 6
std_factor = 0.5; %default: 0.5

source_path = get_path('source');
template_dir = get_path('template');


%------------------------
%MAIN SCRIPT
%------------------------
%addpath('utils');

% controls selection at file level
[controls_paths, ~] = select_files(source_path, "*.nii", "manual", "Select the nifti images of the controls", 1);
[controls_dir, ~, ~] = fileparts(controls_paths(1));

% controls selection at directory level (for debugging)
%controls_dir = select_dir(source_path, "Select the directory were the controls are located", 1);
%[controls_paths,~] = select_files(controls_dir, "*.nii", "auto", "", 1);

% patient selection at file level
patients_paths = select_files(source_path, "*.nii", "manual", "Select the nifti images of the patients", 1);

% Check if niftis were preprocessed, if not, runs preprocessing step
% ETA: 15~20min per nifti
all_paths = [controls_paths; patients_paths];
prepro_check = check_prepro(all_paths);
if sum(prepro_check) ~= 0
    to_prepro = all_paths(logical(prepro_check));
    cat_preprocess(to_prepro);
end

%mask to ignore non-cortial regions: thalamus, cerebrellum, brainstem and basal ganglia
%ncort_labels = [35 36 37 38 39 40 41 55 56 57 58 59 60 61 62 71 72 73 75 76];
ncort_labels = [];
excluded_regions = get_mask(template_dir, ncort_labels);

% Check if the references images were created and loads it, if not, runs the required step
ref_check = check_references(controls_dir);
if ~ref_check
    [j_mean, e_mean, e_std] = generate_references(controls_paths, excluded_regions, kernel_conv, kernel_smoothing, std_factor);
else
    [j_mean, e_mean, e_std] = load_references(controls_dir);
end

% Generate junction and extension maps for every selected patient
generate_maps(patients_paths, j_mean, e_mean, e_std, excluded_regions, kernel_conv, kernel_smoothing, std_factor);

fprintf('[INFO]Elapsed time %.2f minutes\n[INFO]Job done!\n', double(toc/60));
