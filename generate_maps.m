%Computes the Junction and Extension maps for FCD detection based on the following publication:
%   Hans-Jurgen Huppertz, Christina Grimm, Susanne Fauser, Jan Kassubek, Irina Mader, Albrecht Hochmuth,
%   Joachim Spreer, and Andreas SchulzeBonhage. Enhanced visualization of blurred gray{white matter junctions
%   in focal cortical dysplasia by voxel-based 3d mri analysis. Epilepsy research,67(1-2):35-50,2005.
%
%Before executing this script you need:
%1.NIFTI images of the control group (registered and normalized brain, GM and WM)
%2.NIFTI images of the sbjects to analyze (registered and normalized brain, GM and WM)
%3.Neuromorphometrics template
%4.The ground truth of the lesion in case you want to calculate the accuracy of the maps for detecting FCD

function generate_maps(paths, j_mean, e_mean, e_std, mask, kernel_conv, kernel_smoothing, std_factor)

    warning('off','all');
    %PARAMETERS------------------------------------------------------------------------------------
    %ground_truth_path = 'D:\Pladema\Datos\sauce\HEC\JP\FCD\segments_cat12\mri\fcd_maps\FCD_011\wrFLAIR_FCD_011.nii';
    ground_truth_path = '';
    output_dir = get_path('maps');
    
    calculate_metrics = 0;
    save_intermediate_image = 0;
    %SCRIPT---------------------------------------------------------------------------------------

    fprintf('[INFO]Generating junction and extension maps...\n');
    
    n_patients = size(paths,1);
    for p = 1:n_patients
        %JMAP generation
        [img_brain, img_gm, img_wm, h] = load_brain_images(paths(p), mask);
        [img_conv, img_bin] = get_convolution(img_brain, img_gm, img_wm, std_factor, kernel_conv);

        j_map = img_conv - j_mean;
        j_map(j_map<0) = 0;

        %EMAP generation
        img_smooth = get_smoothing(img_gm,kernel_smoothing);
        e_diff = img_smooth - e_mean;
        e_map = e_diff;
        e_map(e_diff < e_std) = 0;
        e_map = e_map.^2;

        [folder, file, ext] = fileparts(paths(p,:));
        output_path = fullfile(folder, output_dir);
        if ~exist(output_path,'dir'), mkdir(output_path); end

        %save JMAP results
        save_nifti(h, j_map, fullfile(output_path, strcat('junction_map_',file,ext)));

        %EMAP results saving
        save_nifti(h, e_map, fullfile(output_path, strcat('extension_map_',file,ext)));
        
        if save_intermediate_image
            save_nifti(h, img_bin, fullfile(output_dir, strcat('junction_bin_',file,ext)));
            save_nifti(h, img_conv, fullfile(output_dir, strcat('junction_conv_',file,ext)));
            
            save_nifti(h, img_smooth, fullfile(output_dir, strcat('extension_smooth_',file,ext)));
            save_nifti(h, e_diff, fullfile(output_dir, strcat('extension_diff_',file,ext)));
        end
        %fprintf('[INFO]Maps saved for patient %s\n', file);
    end

    if calculate_metrics
        metrics = performance_metrics(e_map, j_map, load_nifti(ground_truth_path));
    end
    
    %fprintf('[INFO]Job done!\n');
    warning('on','all');

end