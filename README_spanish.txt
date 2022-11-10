(1) Requisitos:
	>Matlab R2018b instalado
	>SPM12 for Matlab instalado
		>Descargar de https://www.fil.ion.ucl.ac.uk/spm/software/download/
		>Extraer en cualquier carpeta
		>Agregar la dirección de SPM en los paths de Matlab
	>CAT12.8.1 (r2043) plugin para SPM
		>Descargar de http://www.neuro.uni-jena.de/cat12/
		>Mover la carpeta de CAT12 a <spm_dirección>/toolbox y agregar a los paths de Matlab

(2) Uso del programa:
	>Correr el script "run_fcd_maps.m"
	>Solo si es necesario, modificar los "CONFIGURATION PARAMETERS" (recomendado dejar en default)
	>Primero se solicita seleccionar cada una de las imagenes nifti de los controles originales (en espacio nativo)
	>Segundo se solicita seleccionar cada uno de las las imágenes de los pacientes originales (en espacio nativo) a los cuales se les quiere generar los mapas
	>Las imágenes que no se encuentren pre-procesadas serán procesadas con CAT12
	>Los mapas de referencia serán calculados solamente si no existe la carpeta "references" en la carpeta de los controles
	>Los mapas de los pacientes serán guardados y sobreescritos en la carpeta maps dentro de la carpeta de los pacientes
	
(3) Notas:
	>Las imágenes pre-procesadas deben ir dentro de una carpeta llamada "mri" dentro de la carpeta de las imágenes originales
	>Si se requiere volver a generar los mapas de referencia, se deberá eliminar la carpeta "references" dentro de la carpeta de los controles
	>Los resultados del pre-procesamiento son las siguientes imágenes:
		(wm*) Cerebro completo normalizado
		(wp1*) Materia gris normalizada
		(wp2*) Materia blanca normalizada
		(p0*) Cerebro completo segmentado en espacio nativo
		(y_*) Matriz de deformación para convertir del espacio nativo al template
		(yi_*) Matriz de deformación para convertir del espacio del template al nativo