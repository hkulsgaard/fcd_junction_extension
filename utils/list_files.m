%This function return a string array with the files inside the path

function [flist, n] = list_files(path, pattern, verbose)
    if exist(path,'dir') == 7
        dir_struct = dir(strcat(path,filesep,pattern));
        n_files = size(dir_struct,1);
        offset = 0;

        %if there is no pattern, the first two positions are skipped ("." and "..")
        if pattern=="", offset = 2;end
        n = n_files - offset;

        %store all file names from the struct and convert it to an string array
        flist = string({dir_struct.name}');
    else
        error('[ERROR]"%s" is not a valid directory\n',path);
    end

    if verbose
        fprintf('[INFO]Scanned directory: "%s"\n', path);
        fprintf('	>File: "%s"\n',flist);
    end
end