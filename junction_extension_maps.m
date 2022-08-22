%This script computes the Junction and Extension maps for FCD detection based on the following publication:
%   Hans-Jurgen Huppertz, Christina Grimm, Susanne Fauser, Jan Kassubek, Irina Mader, Albrecht Hochmuth,
%   Joachim Spreer, and Andreas SchulzeBonhage. Enhanced visualization of blurred gray{white matter junctions
%   in focal cortical dysplasia by voxel-based 3d mri analysis. Epilepsy research,67(1-2):35-50,2005.
%
%Before executing this script you need:
%1.NIFTI images of the control group (registered and normalized brain, GM and WM)
%2.NIFTI images of the sbjects to analyze (registered and normalized brain, GM and WM)
%3.Neuromorphometrics template
%4.The ground truth of the lesion in case you want to calculate the accuracy of the maps for detecting FCD

clear;clc;warning('off','all');
%PARAMETERS------------------------------------------------------------------------------------
pathCtrl = 'D:\Pladema\Datos\sauce\HEC\JP\Controls\nii\segments_cat12_2\';
pathFCD = 'D:\Pladema\Datos\sauce\HEC\JP\FCD\segments_cat12\';
templateDir = 'D:\Development\SPM\spm\tpm\labels_Neuromorphometrics.nii';
pathGT = 'D:\Pladema\Datos\sauce\HEC\JP\FCD\segments_cat12\mri\fcd_maps\FCD_011\wrFLAIR_FCD_011.nii';
outDir = 'fcd_maps';

subjectSelect = "auto";%auto or manual
save_intermediate_images = true;
calculate_metrics = true;

kernel_conv = 5;
kernel_smoothing = 6;
stdFactor = 0.5;

%SCRIPT---------------------------------------------------------------------------------------

%mask to ignore non-cortial regions: thalamus, cerebrellum, brainstem and basal ganglia
ncort_labels = [35 36 37 38 39 40 41 55 56 57 58 59 60 61 62 71 72 73 75 76];
fcdMask = get_mask(templateDir, ncort_labels);

%First we need to generate the control's maps
[pathsCtrl, pathsCtrlGM, pathsCtrlWM, nCtrls] = load_paths(pathCtrl,'auto');
fprintf('[INFO]Generating controls map...\n');
smooths = zeros(nCtrls, size(fcdMask,1), size(fcdMask,2),size(fcdMask,3));
for c = 1:nCtrls 
    [imgBrain, imgGM, imgWM] = load_brain_images(pathsCtrl(c,:), pathsCtrlGM(c,:), pathsCtrlWM(c,:), fcdMask);
    imgConv = get_convolution(imgBrain, imgGM, imgWM, stdFactor, kernel_conv);
    if c==1, jMean = zeros(size(imgConv)); end                                            
    %if c==1, eMap_controls = zeros(size(imgConv));  end
    jMean = imgConv + jMean;
    
    imgSmooth = get_smoothing(imgGM,kernel_smoothing);
    smooths(c,:,:,:) = imgSmooth;
    %eMap_controls = eMap_controls + imgSmooth;
end
jMean = jMean/nCtrls;
%eMap_controls = eMap_controls/nControls;
eMean = mean(smooths);
eMean = reshape(eMean,[size(fcdMask,1) size(fcdMask,2) size(fcdMask,3)]);
eStd = std(smooths);
eStd = reshape(eStd,[size(fcdMask,1) size(fcdMask,2) size(fcdMask,3)]);
clear smooths;

%Now we can get the Juntion and Extension maps for the subjects
[pathsSub,pathsSubGM,pathsSubWM,nSubs] = load_paths(pathFCD,subjectSelect);
mkdir(strcat(pathFCD,'mri',filesep,outDir));
fprintf('[INFO]Generating junction and extension maps...\n');
for s = 11:11
%for s = 1:nSubs
    %JMAP generation
    [imgBrain, imgGM, imgWM, h] = load_brain_images(pathsSubGM(c,:), pathsSubGM(c,:), pathsSubWM(c,:), fcdMask);
    [imgConv, imgBin] = get_convolution(imgBrain, imgGM, imgWM, stdFactor, kernel_conv);
    
    jMap = imgConv - jMean;
    jMap(jMap<0) = 0;
    
    %EMAP generation
    imgSmooth = get_smoothing(imgGM,kernel_smoothing);
    eDiff = imgSmooth - eMean;
    eMap = eDiff;
    eMap(eDiff<eStd) = 0;
    eMap = eMap.^2;
    
    [folder, file, ext] = fileparts(pathsSub(s,:));
    
    %save JMAP results
    save_nifti(h, jMap, strcat(folder(1:end-2),outDir,filesep,'jMap_',file,ext));
    fprintf('[INFO]Junction Map saved in: "%s"\n',h.fname);
    
    %EMAP results saving
    save_nifti(header, eMap, strcat(folder(1:end-2),outputDir,filesep,'eMap_',file,ext)));
    fprintf('[INFO]Extension Map saved in: "%s"\n',h.fname);
    
    if save_intermediate_image
        save_nifti(h, imgBin, strcat(folder(1:end-2),outDir,filesep,'jBin_',file,ext));
        save_nifti(h, imgConv, strcat(folder(1:end-2),outDir,filesep,'jConv_',file,ext));
        
        save_nifti(h, imgSmooth), strcat(folder(1:end-2),outputDir,filesep,'eSmooth_',file,ext));
        save_nifti(h, eDiff, strcat(folder(1:end-2),outDir,filesep,'eDiff_',file,ext));
    end
    
end

if save_intermediate_image
    save_nifti(h, jMean, strcat(folder(1:end-2),outDir,filesep,'jMean_',file,ext));

    save_nifti(h, eMean, strcat(folder(1:end-2),outDir,filesep,'eMean_',file,ext));
    save_nifti(h, eStd, strcat(folder(1:end-2),outDir,filesep,'eStd_',file,ext));
end

if calculate_metrics, metrics = performance_metrics(eMap, jMap, load_nifti(pathGT)); end

fprintf('[INFO]Job done!\n');warning('on','all');

%END-OF-SCRIPT----------------------------------------------------------------------------------------

function [subjectPaths,gmPaths,wmPaths,nSubs] = load_paths(cat12_path,subjectSelect)
    if subjectSelect == "manual"
        [subjectPaths,nSubs] = select_elements([1 Inf],'.nii','Select subjects images (wm*)',strcat(cat12_path,'mri'),1);
        [gmPaths,~] = select_elements([1 Inf],'.nii','Select grey matter images (wp1*)',strcat(cat12_path,'mri'),1);
        [wmPaths,~] = select_elements([1 Inf],'.nii','Select white matter images (wp1*)',strcat(cat12_path,'mri'),1);
    else
        subjectPaths = strcat(cat12_path,'mri',filesep,'wm',filesep,ls(strcat(cat12_path,'mri',filesep,'wm',filesep,'wm*.nii')));
        gmPaths = strcat(cat12_path,'mri',filesep,'wp1',filesep,ls(strcat(cat12_path,'mri',filesep,'wp1',filesep,'wp1*.nii')));
        wmPaths = strcat(cat12_path,'mri',filesep,'wp2',filesep,ls(strcat(cat12_path,'mri',filesep,'wp2',filesep,'wp2*.nii')));
        nSubs = size(subjectPaths,1);
    end
end

function [imgBrain, imgGM, imgWM, header] = load_brain_images(pathBrain, pathGM, pathWM, mask)
%Loads the next images: complete brain, gray matter only and white matter only
    [imgBrain,header] = load_nifti(pathBrain);
    imgGM = load_nifti(pathGM);
    imgWM = load_nifti(pathWM);
    
    %set to 0 those voxels where the mask is present
    if ~isempty(mask)
        imgBrain(fcdMask == 1) = 0;
        imgGM(fcdMask == 1) = 0;
        imgWM(fcdMask == 1) = 0;
    end
    
end

function smoothed_img = get_smoothing(img, kernel)
%Smoothing calculated using the function provided in the SPM library
    smoothed_img = zeros(size(img));
    spm_smooth(gm_img,smoothed_img,[kernel kernel kernel]);
end