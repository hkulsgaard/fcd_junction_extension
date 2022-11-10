function [paths,max_elements] = select_elements(files_range,element_type,title,initial_dir,verbose)
if exist(initial_dir,'dir') == 7
    paths = spm_select(files_range,element_type,title,'',initial_dir);
else
    %fprintf('[WARNING]"%s" is not a valid directory\n',initial_dir);
    paths = spm_select(files_range,element_type,title);
end
max_elements = size(paths,1);
if max_elements == 0
    paths = 0;
    error('[ERROR]No elements selected');
end

fprintf('[INFO]Selected %i "%s" elements\n',max_elements,element_type);
for i=1:max_elements
    [folder,file,ext] = fileparts(paths(i,:));
    if size(ext,2) > 4
        ext = ext(1:4);
    end
    if verbose
        fprintf('(%i)%s\\%s%s\n',i,folder,file,ext);
    end
end
end