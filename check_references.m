function check = check_references(path)
    check = 1;
    files = strcat("ref_",["junction_mean";"extension_mean";"extension_std"],".nii");
    path = fullfile(path,'references');
    
    for f = 1:size(files,1)
        ref_path = fullfile(path,files(f));
        if ~exist(ref_path,'file')
            check = 0;
        end
    end
end