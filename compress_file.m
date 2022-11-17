function output = compress_file(path, del_file)
    output = 0;
    zip_path = get_path('7z');
    if exist(zip_path, 'file')
        new_path = strcat(path, ".gz");
        command = strcat(zip_path, " a -mx5 ", new_path, " ", path);
        [status,~] = system(command);

        if del_file && exist(new_path,'file')
            delete(path);
        end
        output = 1;
    end
end

