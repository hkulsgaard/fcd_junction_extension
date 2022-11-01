function mask = get_mask(templateDir, ignore) 
    [template,~] = load_nifti(templateDir);
    mask = zeros(size(template));
    for l = 1:numel(ignore)
        mask(template==ignore(l)) = 1;
    end
end