%This scrip does the following:
%1.Load data from the cat12 reports
%2.Load the normalized brain images
%3.Computes extension and junction maps

%https://www.mathworks.com/matlabcentral/fileexchange/17997-minimamaxima3d
%https://www.mathworks.com/help/matlab/ref/islocalmax.html
%

clear;clc;warning('off','all');
%VARIABLES------------------------------------------------------------------------------------
subjectSelect = "auto";%auto or manual
save_intermediate_images = 1;
calculate_metrics = 1;
controlsPath = 'D:\Pladema\Datos\sauce\HEC\JP\Controls\nii\segments_cat12_2\';
%fcdPath = 'D:\Pladema\Datos\sauce\HEC\JP\Controls\nii\segments_cat12_2\';
%fcdPath = 'D:\Pladema\Datos\sauce\HEC\JP\FCD\segments_cat12\';
fcdPath = 'D:\Pladema\Datos\sauce\HEC\JP\FCD\segments_cat12\';
templateDir = 'D:\Development\SPM\spm\tpm\labels_Neuromorphometrics.nii';
outputDir = 'fcd_maps';
kernel_conv = 5;
kernel_smoothing = 6;
stdFactor = 0.5;
gtPath = 'D:\Pladema\Datos\sauce\HEC\JP\FCD\segments_cat12\mri\fcd_maps\FCD_011\wrFLAIR_FCD_011.nii';

%SCRIPT---------------------------------------------------------------------------------------

%mask to ignore non-cortial regions: thalamus, cerebrellum, brainstem and basal ganglia
ignore_labels = [35 36 37 38 39 40 41 55 56 57 58 59 60 61 62 71 72 73 75 76];
fcdMask = get_mask(templateDir, ignore_labels);

%generate controls map
[controlsPaths, cgmPaths, cwmPaths, ~, nControls] = load_paths(controlsPath,'auto');
fprintf('[INFO]Generating controls map...\n');
smooths = zeros(nControls, size(fcdMask,1), size(fcdMask,2),size(fcdMask,3));
for c = 1:nControls 
    [convolved_img, header, ~] = calculate_convolved_img(controlsPaths(c,:), cgmPaths(c,:),...
                                                      cwmPaths(c,:), [],...
                                                      fcdMask, stdFactor, kernel_conv);
    if c==1, jMean = zeros(size(convolved_img)); end                                            
    %if c==1, eMap_controls = zeros(size(convolved_img));  end
    jMean = convolved_img + jMean;
    
    smoothed_img = get_smoothed_img(cgmPaths(c,:),kernel_smoothing,fcdMask);
    smooths(c,:,:,:) = smoothed_img;
    %eMap_controls = eMap_controls + smoothed_img;
end
jMean = jMean/nControls;
%eMap_controls = eMap_controls/nControls;
eMean = mean(smooths);
eMean = reshape(eMean,[size(fcdMask,1) size(fcdMask,2) size(fcdMask,3)]);
eStd = std(smooths);
eStd = reshape(eStd,[size(fcdMask,1) size(fcdMask,2) size(fcdMask,3)]);
clear smooths;

%maps generation
[subjectPaths,gmPaths,wmPaths,~,nSubs] = load_paths(fcdPath,subjectSelect);
mkdir(strcat(fcdPath,'mri',filesep,outputDir));
fprintf('[INFO]Generating junction and extension maps...\n');
for s = 11:11
%for s = 1:nSubs
    %JMAP generation
    [convolved_img, header, binary_img] = calculate_convolved_img(subjectPaths(s,:), gmPaths(s,:),...
                                                      wmPaths(s,:), [],...
                                                      fcdMask, stdFactor, kernel_conv);
    jMap = convolved_img - jMean;
    jMap(jMap<0) = 0;
    
    %EMAP generation
    smoothed_img = get_smoothed_img(gmPaths(s,:),kernel_smoothing,fcdMask);
    eDiff = smoothed_img - eMean;
    eMap = eDiff;
    eMap(eDiff<eStd) = 0;
    eMap = eMap.^2;
    
    [folder, file, ext] = fileparts(subjectPaths(s,:));
    
    %JMAP results saving
    save_nifti(header, jMap, strcat(folder(1:end-2),outputDir,filesep,'jMap_',file,ext));
    %header.fname = strcat(folder(1:end-2),outputDir,filesep,'jMap_',file,ext);
    %spm_write_vol(header, jMap);
    fprintf('[INFO]Junction Map saved in: "%s"\n',header.fname);
    
    %EMAP results saving
    save_nifti(header, eMap, strcat(folder(1:end-2),outputDir,filesep,'eMap_',file,ext)));
    %header.fname = strcat(folder(1:end-2),outputDir,filesep,'eMap_',file,ext);
    %spm_write_vol(header, eMap);
    fprintf('[INFO]Extension Map saved in: "%s"\n',header.fname);
    
    if save_intermediate_images == 1
        save_nifti(header, binary_img, strcat(folder(1:end-2),outputDir,filesep,'jBin_',file,ext));
        %header.fname = strcat(folder(1:end-2),outputDir,filesep,'jBin_',file,ext);
        %spm_write_vol(header, binary_img);
        save_nifti(header, convolved_img, strcat(folder(1:end-2),outputDir,filesep,'jConv_',file,ext));
        %header.fname = strcat(folder(1:end-2),outputDir,filesep,'jConv_',file,ext);
        %spm_write_vol(header, convolved_img);
        
        save_nifti(header, smoothed_img), strcat(folder(1:end-2),outputDir,filesep,'eSmooth_',file,ext));
        %header.fname = strcat(folder(1:end-2),outputDir,filesep,'eSmooth_',file,ext);
        %spm_write_vol(header, smoothed_img);
        save_nifti(header, eDiff, strcat(folder(1:end-2),outputDir,filesep,'eDiff_',file,ext));
        %header.fname = strcat(folder(1:end-2),outputDir,filesep,'eDiff_',file,ext);
        %spm_write_vol(header, eDiff);
    end
    
end

if save_intermediate_images == 1
    save_nifti(header, jMean, strcat(folder(1:end-2),outputDir,filesep,'jMean_',file,ext));
    %header.fname = strcat(folder(1:end-2),outputDir,filesep,'jMean_',file,ext);
    %spm_write_vol(header, jMean);

    save_nifti(header, eMean, strcat(folder(1:end-2),outputDir,filesep,'eMean_',file,ext));
    %header.fname = strcat(folder(1:end-2),outputDir,filesep,'eMean_',file,ext);
    %spm_write_vol(header, eMean);
    save_nifti(header, eStd, strcat(folder(1:end-2),outputDir,filesep,'eStd_',file,ext));
    %header.fname = strcat(folder(1:end-2),outputDir,filesep,'eStd_',file,ext);
    %spm_write_vol(header, eStd);
end

if calculate_metrics == 1
    metrics = performance_metrics(eMap, jMap, gtPath);
end

fprintf('[INFO]Job done!\n');warning('on','all');

%pruebas iniciales
%eMap2 = eMap;
%eMap2(eMap2<0.01)=0;
%[eMap2_d1_maxs,eMap2_d1_proms] = islocalmax(eMap2,1);
%[eMap2_d2_maxs,eMap2_d2_proms] = islocalmax(eMap2,2);
%[eMap2_d3_maxs,eMap2_d3_proms] = islocalmax(eMap2,3);

%END-OF-SCRIPT----------------------------------------------------------------------------------------

function [subjectPaths,gmPaths,wmPaths,reportPaths,nSubs] = load_paths(cat12_path,subjectSelect)
    if subjectSelect == "manual"
        [subjectPaths,nSubs] = select_elements([1 Inf],'.nii','Select subjects images (wm*)',strcat(cat12_path,'mri'),1);
        [gmPaths,~] = select_elements([1 Inf],'.nii','Select grey matter images (wp1*)',strcat(cat12_path,'mri'),1);
        [wmPaths,~] = select_elements([1 Inf],'.nii','Select white matter images (wp1*)',strcat(cat12_path,'mri'),1);
        %[reportPaths,~] = select_elements([1 Inf],'.nii','Select subjects images',strcat(cat12_path,'report'),1);
    else
        subjectPaths = strcat(cat12_path,'mri',filesep,'wm',filesep,ls(strcat(cat12_path,'mri',filesep,'wm',filesep,'wm*.nii')));
        gmPaths = strcat(cat12_path,'mri',filesep,'wp1',filesep,ls(strcat(cat12_path,'mri',filesep,'wp1',filesep,'wp1*.nii')));
        wmPaths = strcat(cat12_path,'mri',filesep,'wp2',filesep,ls(strcat(cat12_path,'mri',filesep,'wp2',filesep,'wp2*.nii')));
        %reportPaths = strcat(cat12_path,'report',filesep,ls(strcat(cat12_path,'report',filesep,'cat_*.mat')));
        nSubs = size(subjectPaths,1);
    end
    reportPaths = 0;
end

function [convolved_img, header, binary_img] = calculate_convolved_img(subjectPath, gmPath, wmPath,...
                                                           reportPath, fcdMask, stdFactor, kernel_size)
    %load data
    [header,brain_img] = load_nifti(subjectPath);
    [~,gm_img] = load_nifti(gmPath);
    [~,wm_img] = load_nifti(wmPath);
    brain_img(fcdMask == 1) = 0;
    gm_img(fcdMask == 1) = 0;
    wm_img(fcdMask == 1) = 0;
    %report = load(reportPath);
    
    %huppertz2015 > junction map > Step 3 - Conversion to binary image
    %t_lower_tresh = report.S.qualitymeasures.tissue_mnr(3) + 0.5 * report.S.qualitymeasures.tissue_stdr(3);
    %t_upper_tresh = report.S.qualitymeasures.tissue_mnr(4) - 0.5 * report.S.qualitymeasures.tissue_stdr(4);
    t_lower_tresh = mean(brain_img(gm_img(:)>0.49)) + stdFactor * std(brain_img(gm_img(:)>0.49));
    t_upper_tresh = mean(brain_img(wm_img(:)>0.49)) - stdFactor * std(brain_img(wm_img(:)>0.49));
    binary_img = zeros(size(brain_img));
    binary_img(brain_img >= t_lower_tresh & brain_img <= t_upper_tresh) = 1;
    %masking out some labels
    %binary_img(fcdMask == 1) = 0;
      
    %huppertz2015 > junction map > Step 4 - Convolution
    convolved_img = convn(binary_img,ones([kernel_size kernel_size kernel_size]),'same');
    convolved_img = convolved_img/100;
    
    %for i=40:2:75
        %imshow(junction_img(:,:,i),[min(junction_img(:)) max(junction_img(:))])
        %pause(0.25)
    %end
end

function smoothed_img = get_smoothed_img(gmPath, kernel, fcdMask)
    [~,gm_img] = load_nifti(gmPath);
    gm_img(fcdMask == 1) = 0;
    smoothed_img = zeros(size(gm_img));
    spm_smooth(gm_img,smoothed_img,[kernel kernel kernel]);
end

%function fcdMask = get_mask(templateDir, ignore)
%    %Here we generate the fcdMask to ignore non-cortial regions (thalamus,
%    %cerebrellum, brainstem and basal ganglia)
%    ignore = [35 36 37 38 39 40 41 55 56 57 58 59 60 61 62 71 72 73 75 76];
%    [~,template] = load_nifti(templateDir);
%    fcdMask = zeros(size(template));
%    for l = 1:numel(ignore)
%        fcdMask(template==ignore(l)) = 1;
%    end
%end

%function metrics = calculate_performance_metrics(eMap, jMap, gtPath)
%    gtMask = spm_read_vols(spm_vol(gtPath));
%    n_mask_voxels = sum(gtMask(:)==1);
%    
%    eTruePos = sum((eMap(:) & gtMask(:)));
%    jTruePos = sum((jMap(:) & gtMask(:)));
%    metrics.eSens = eTruePos / n_mask_voxels;
%    metrics.jSens = jTruePos / n_mask_voxels;
%    
%    
%    n_eVoxels = sum(eMap(:)>0);
%    n_jVoxels = sum(jMap(:)>0);
%    metrics.ePres = eTruePos / n_eVoxels;
%    metrics.jPres = jTruePos / n_jVoxels;
%end