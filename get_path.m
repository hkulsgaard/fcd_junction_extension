function path = get_path(id)
    switch id
        case 'source'
            path = fwd;
            
        case 'template'
            path = fullfile('template','labels_Neuromorphometrics.nii');
            
        case 'maps'
            path = 'maps';
        
        case 'references'
            path = 'references';
            
        case 'cat12_template'
            path = fullfile('template','TPM.nii')';
            
        case 'segments'
            path = 'mri';
        
        case 'prepro_module'
            path = 'cat12_prepro_module.mat';
         
        case '7z'
            path = fullfile("7zip", "7za.exe");
        
        otherwise
            error("[ERROR]Unknown selected path")
    
    end
end

