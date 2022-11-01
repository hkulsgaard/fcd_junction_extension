function smoothed_img = get_smoothing(img, kernel)
%Smoothing calculated using the function provided in the SPM library
    smoothed_img = zeros(size(img));
    spm_smooth(img,smoothed_img,[kernel kernel kernel]);
end