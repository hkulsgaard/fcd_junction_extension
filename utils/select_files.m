function [files,n_files] = select_files(path, pattern, select_mode, title, verbose)
% Function to select files using GUI
% path: source path to open the selection window
% pattern: pattern to filter files to be selected
% select_mode: "manual"-> select each file manually / "auto"-> files are
%               automatically selected from a directory using the pattern
% 
% files: array of strings with the absolute path for each
% n_files: amount of selected files
    switch select_mode
        case "manual"
            filter = {pattern,strcat('Pattern-files (',pattern,')'); '*.*', 'All Files (*.*)'};
            [files,path] = uigetfile(filter, title, path, 'MultiSelect', 'on');
            
            if path(1)==0
                n_files = 0;
            else
                if iscell(files)
                    files = string(files)';
                else
                    files = string(files);
                end
                n_files = size(files,1);
            end       
            
        case "auto"
            [files,n_files] = list_files(path, pattern, false);
            
        otherwise
            error('[ERROR]Selection mode not recognized');
            
    end
    
    if n_files == 0
        error('[ERROR]No files were selected');
    end
    
    %adds the folder to get the absolute paths
    files = fullfile(path,files);
    
    if verbose, fprintf('[INFO]Selected file: %s\n',files); end
end