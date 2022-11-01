% Checks if the niftis were preprocessed.
% Returns and array with 1 (files exists) or 0 (files doesn't exists)

% PARAMETERS:
% paths -> array of strings with the paths of each nifti image

function checks = check_prepro(paths)

seg_prefixes = ["wm";"wp1";"wp2"];
checks = zeros(size(paths));

%check_prepro(niftis)
for p = 1:size(paths,1)
    [folder,file,ext] = fileparts(paths(p));
    seg_path = fullfile(folder, get_path('segments'));
    
    % for each prefix checks its existance
    for pre = 1:size(seg_prefixes,1)
        check = exist(fullfile(seg_path,filesep,strcat(seg_prefixes(pre),file,ext)),'file');
        if check ~= 2
            checks(p) = 1;
        end
    end
end
