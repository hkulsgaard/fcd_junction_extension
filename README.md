# FCD maps: Junction and Extension
Implementation of Junction and Extension maps for automatic detection of Focal Cortical Dysplasia using brain MRI

(1) Requirements:
	>Matlab R2018b installed
	>SPM12 for Matlab installed 
		>Download from https://www.fil.ion.ucl.ac.uk/spm/software/download/
		>Add SPM's path to Matlab path
	>CAT12.8.1 (r2043) plugin for SPM
		>Download from http://www.neuro.uni-jena.de/cat12/
		>Move cat12 folder to <spm_dir>/toolbox and add this path to Matlab path

(2) Usage:
	>Run the main script "run_fcd_maps.m"
	>If neccesary, set the configuration parameters before running the script
	>First, you need to select all the control images in nifti format in native space
	>Second, you need to select the patients images in nifti format in native space
	>Those images that are not preprocessed will be proccesed with the CAT12 segmentation pipeline
	>Reference maps will be calcultade only if there is no "references" directory inside the control's dir
	>Calculated maps will be located and overwritten in the "maps" directory inside the patients dir

	
(3) Notes:
	>Pre-processed images need to be in the directory "mri" inside the original image dir
	>If you want to re-generate the reference images, you need to delete the reference dir inside control's dir
	>The images created by the pre-processing step will be:
		>(wm*)  All brain normalized
		>(wp1*) Grey matter normalized
		>(wp2*) White matter normalized
		>(p0*)  All brain segmented with labels in native space (not required for map generation)
		>(yi_*) Transformation matrix from template to native space (not required for map generation)
		>(y_*) Transformation matrix from native to template space (not required for map generation)