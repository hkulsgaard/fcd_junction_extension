function metrics = performance_metrics(eMap, jMap, gtMask)
    n_mask_voxels = sum(gtMask(:)==1);
    
    eTruePos = sum((eMap(:) & gtMask(:)));
    jTruePos = sum((jMap(:) & gtMask(:)));
    metrics.eSens = eTruePos / n_mask_voxels;
    metrics.jSens = jTruePos / n_mask_voxels;
    
    
    n_eVoxels = sum(eMap(:)>0);
    n_jVoxels = sum(jMap(:)>0);
    metrics.ePres = eTruePos / n_eVoxels;
    metrics.jPres = jTruePos / n_jVoxels;
end