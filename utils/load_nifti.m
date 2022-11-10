%This function loads a NIFTI image using the SPM library
%Output: "h" is the header of the nifti and "img" is the 3D matrix with the
%voxels of the image
%Usage: [,] = load_nifti()
function [img, h] = load_nifti(path)
    if isstring(path),path = char(path);end
    h = spm_vol(path);
    img = spm_read_vols(h);
end