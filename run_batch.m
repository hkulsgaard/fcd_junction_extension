function result = run_batch(myBatch)
    for b=1:size(myBatch,2)
        fprintf('################################################################');
        fprintf('\n[INFO] Processing batch %i/%i...\n',b,size(myBatch,2));
        fprintf('################################################################\n');
        spm_jobman('run',myBatch(b).matlabbatch);
    end
    result = 1;
end