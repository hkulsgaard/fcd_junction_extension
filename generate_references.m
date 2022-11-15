function [j_mean, e_mean, e_std] = generate_references(controls_paths, mask, kernel_conv, kernel_smoothing, std_factor)
    
    fprintf('[INFO]Generating reference images...\n');
    
    [~,h] = load_nifti(get_path("cat12_shooting"));
    img_size = h.dim;
    n_controls = size(controls_paths,1);
    smooths = zeros([n_controls img_size]);

    for c = 1:n_controls 
        [img_brain, img_gm, img_wm, h] = load_brain_images(controls_paths(c), mask);

        img_conv = get_convolution(img_brain, img_gm, img_wm, std_factor, kernel_conv);

        if c==1, j_mean = zeros(size(img_conv)); end                                            
        %if c==1, e_map_controls = zeros(size(img_conv));  end

        j_mean = img_conv + j_mean;

        img_smooth = get_smoothing(img_gm, kernel_smoothing);
        smooths(c,:,:,:) = img_smooth;
        %eMap_controls = eMap_controls + imgSmooth;
    end
    j_mean = j_mean/n_controls;
    %eMap_controls = eMap_controls/nControls;
    e_mean = mean(smooths,1);
    e_mean = reshape(e_mean, img_size);
    e_std = std(smooths);
    e_std = reshape(e_std, img_size);
    clear smooths;
    
    % save reference images as nifti
    [folder, ~, ~] = fileparts(controls_paths(1));
    output_dir = fullfile(folder, get_path('references'));
    if ~exist(output_dir,'dir'), mkdir(output_dir); end
    
    save_nifti(h, j_mean, fullfile(output_dir,strcat('ref_junction_mean.nii')));
    save_nifti(h, e_mean, fullfile(output_dir,strcat('ref_extension_mean.nii')));
    save_nifti(h, e_std, fullfile(output_dir,strcat('ref_extension_std.nii')));
end

