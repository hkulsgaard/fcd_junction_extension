function status = save_nifti(h, img, fname)
    status = 0;    
    h.fname = char(fname);
    spm_write_vol(h,img);
    status = 1;
end