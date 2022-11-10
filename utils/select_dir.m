function folder = select_dir(path, title, verbose)

    folder = uigetdir(path, title);
    folder = string(folder);
    
    if (folder == "0"), error('[ERROR]There was not directory selected'); end
    if verbose, fprintf('[INFO]Selected folder: %s\n',folder); end
end