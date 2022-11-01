function [files,n_files] = select_files(path, pattern, select_mode, title, verbose)

    switch select_mode
        case "manual"
            filter = {pattern,strcat('Pattern-files (',pattern,')'); '*.*', 'All Files (*.*)'};
            [files,path] = uigetfile(filter, title, path, 'MultiSelect', 'on');
            % if multiple files were selected, uigetfile returns cells so
            % is transformed to a string array
            if iscell(files), files = string(files)'; end
            
            % if only one file is selected, uigetfile returns char array,
            % so is transformed to a string
            if size(files,1)==1, files = string(files); end
            n_files = size(files,1);
            
        case "auto"
            [files,n_files] = list_files(path, pattern, false);
        otherwise
            error('[ERROR]Selection mode not recognized');
    end
    
    if (n_files == 0 || path(1)=="0"), error('[ERROR]No files were selected');end
    
    %adds the folder to get the absolute paths
    files = fullfile(path,files);
    
    if verbose, fprintf('[INFO]Selected file: %s\n',files); end
end