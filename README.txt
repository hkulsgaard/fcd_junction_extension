(1) Requisitos:
	>Tener instalada la plataforma Matlab 
	>Tener instalado SPM12 con el plugin CAT12
	>En caso de no tener el plugin CAT12, descargarlo de http://dbm.neuro.uni-jena.de/cat12/cat12_latest.zip
	>Descomprimir y mover la carpeta "cat12" en <carpeta_instalación_SPM>/toolbox

(2) Uso del programa:
	>Abrir Matlab
	>Abrir el script "run_fcd_maps.m"
	>Solo si es necesario, modificar los "CONFIGURATION PARAMETERS"
	>Correr el script
	>Primero se solicita seleccionar el conjunto de imagenes nifti de los control es (utilizado para la generación de las imágenes de referencia)
	>Segundo se solicita seleccionar las imágenes de los pacientes a los cuales se quiere generar los mapas
	>Los mapas serán guardos en la carpeta "maps" junto a las imágenes del paciente
	
(3) Notas:
	>Las imágenes de referencia serán guardadas en la carpeta "references" junto a los controles
	>En el caso de que las imágenes de referencia existan previamente, no se volverán a generar (borrarlas si se desea generarlas nuevamente)
	>Todas las imágenes serán pre-procesadas mediante la herramienta CAT12
	>Aquellas imágenes que ya hayan sido pre-procesadas serán omitidas en este paso
	>Los resultados del pre-procesamiento se encontrarán en la carpeta "mri" junto a las imágenes correspondientes
	>Los resultados del pre-procesamiento son las siguientes imágenes:
		(wm*) Cerebro completo normalizado
		(wp1*) Materia gris normalizada
		(wp2*) Materia blanca normalizada
		(p0*) Cerebro completo segmentado en espacio nativo (No se utiliza)
		(yi_*) Matriz de deformación para convertir del espacio del template al nativo (No se utiliza)