function path = get_path(id)
    switch id
        case "source"
            %path = "D:\Pladema\Datos\sauce\HEC\JP";
            path = pwd;
            
        case "template"
            %path = fullfile(spm('dir'),"tpm","labels_Neuromorphometrics.nii");
            path = fullfile(templates,"labels_Neuromorphometrics.nii")
            
        case "maps"
            path = "maps";
        
        case "references"
            path = "references";
        
        case "cat12_dir"
            path = fullfile(spm('dir'),'toolbox','cat12');
            
        case "cat12_template"
            %path = fullfile(spm('dir'),"tpm","TPM.nii");
            path = fullfile("templates","TPM.nii");
            
        case "cat12_shooting"
            %path = fullfile(get_path("cat12_dir"),"templates_MNI152NLin2009cAsym","Template_0_GS.nii");
            %path = fullfile("templates","Template_0_IXI555_MNI152_GS.nii");
            path = fullfile("templates","Template_0_GS.nii");
            
        case "segments"
            path = "mri";
        
        case "prepro_module"
            path = "cat12_prepro_module.mat";
         
        case "7z"
            path = fullfile("7zip", "7za.exe");
        
        otherwise
            error("[ERROR]Unknown selected path")
    
    end
end

