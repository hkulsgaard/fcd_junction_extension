function output = compress_file(path, del_file)
    output = 0;
    zip_path = get_path('7z');
    if zip_path=="7z" || exist(zip_path, 'file')
        command = strcat(zip_path, " a -mx5 ", path, ".gz ", path);
        [status,~] = system(command);

        if del_file
            delete(path);
        end
        output = 1;
    end
end

