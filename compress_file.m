function status = compress_file(path, del_file)
    zip_path = get_path('7z');
    if exist(zip_path, 'file')
        command = strcat(zip_path, " a -mx5 ", path, ".gz ", path);
        [status,~] = system(command);

        if del_file
            delete(path);
        end
    end
end

