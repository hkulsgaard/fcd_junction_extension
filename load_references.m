function [j_mean, e_mean, e_std] = load_references(controls_dir)
    fprintf('[INFO]Loading reference images...\n');

    output_dir = fullfile(controls_dir, get_path('references'));
    
    j_mean = load_nifti(fullfile(output_dir,'ref_junction_mean.nii'));
    e_mean = load_nifti(fullfile(output_dir,'ref_extension_mean.nii'));
    e_std = load_nifti(fullfile(output_dir,'ref_extension_std.nii'));
end

