% Loads the cat preprocessing modules and runs it
% Requires CAT12 installed
% ETA:10~15 min per image

%PARAMETERS:
%paths -> array of string with the path of the original nifti image

function cat_preprocess(paths)
    fprintf('[INFO]Pre-processing images...\n');
    
    %addpath(get_path("cat12_dir"));
    
    % load pre-configured module for preprocessing
    prepro_batch = load(get_path('prepro_module'));
    prepro_batch.matlabbatch{1,1}.spm.tools.cat.estwrite.data = cellstr(paths);
    prepro_batch.matlabbatch{1,1}.spm.tools.cat.estwrite.opts.tpm = ...
        cellstr(get_path('cat12_template'));
    
    prepro_batch.matlabbatch{1,1}.spm.tools.cat.estwrite.extopts.registration.regmethod.shooting.shootingtpm = ...
        cellstr(get_path('cat12_shooting'));
    
    % run the batch using the CAT12 function 
    % using spm_jobman gives errors of initialization
    %run_batch(prepro_batch)
    warning ('off','all');
    cat_run(prepro_batch.matlabbatch{1,1}.spm.tools.cat.estwrite);
    warning ('on','all');
    
    %compress the files for inversing results (iy) and the labeled normalized
    %images (p0)
    for p = 1:size(paths,1)
        fprintf('[INFO]Compressing images...\n');
        
        [folder, file, ext] = fileparts(paths(p));
        output_dir = fullfile(folder, get_path('segments'));
        
        compress_file(fullfile(output_dir, strcat("iy_",file,ext)),1);
        compress_file(fullfile(output_dir, strcat("y_",file,ext)),1);
        zip_status = compress_file(fullfile(output_dir, strcat("p0",file,ext)),1);
        if zip_status == 0
            fprintf('[INFO]Files were not compressed: 7zip was not found\n');
        end
        
    end
end