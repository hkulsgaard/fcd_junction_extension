%Loads the next images: complete brain, gray matter only and white matter only

function [imgBrain, imgGM, imgWM, header] = load_brain_images(path, mask)
    [folder,file,ext] = fileparts(path);
    
    source_dir = fullfile(folder, get_path('segments'));
    [imgBrain,header] = load_nifti(fullfile(source_dir,strcat('wm',file,ext)));
    imgGM = load_nifti(fullfile(source_dir,strcat('wp1',file,ext)));
    imgWM = load_nifti(fullfile(source_dir,strcat('wp2',file,ext)));
    
    %masking: set to 0 the voxels where the mask is present
    if ~isempty(mask)
        imgBrain(mask == 1) = 0;
        imgGM(mask == 1) = 0;
        imgWM(mask == 1) = 0;
    end
    
end