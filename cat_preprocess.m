% Loads the cat preprocessing modules and runs it
% Requires CAT12 installed
% ETA:10~15 min per image

%PARAMETERS:
%paths -> array of string with the path of the original nifti image

function cat_preprocess(paths)
    fprintf('[INFO]Pre-processing images...\n');

    % load pre-configured module for preprocessing and add niftis
    prepro_batch = load(get_path('prepro_module'));
    prepro_batch.matlabbatch{1,1}.spm.tools.cat.estwrite.data = cellstr(paths);
    prepro_batch.matlabbatch{1}.spm.tools.cat.estwrite.opts.tpm = {fullfile(pwd,get_path('cat12_template'))};

    % run the batch
    %run_batch(prepro_batch)
    
    %compress the files for inversing results (iy) and the labeled normalized
    %images (p0)
    for p = 1:size(paths,1)
        [folder, file, ext] = fileparts(paths(p));
        output_dir = fullfile(folder, get_path('segments'));
        compress_file(fullfile(output_dir, strcat("iy_",file,ext)),1);
        compress_file(fullfile(output_dir, strcat("p0",file,ext)),1);
    end
end