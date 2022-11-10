(1) Requisitos:
	>Tener instalada la plataforma Matlab 
	>Tener instalado SPM12 con el plugin CAT12
	>En caso de no tener el plugin CAT12, descargarlo de http://dbm.neuro.uni-jena.de/cat12/cat12_latest.zip
	>Descomprimir y mover la carpeta "cat12" en <carpeta_instalación_SPM>/toolbox

(2) Uso del programa:
	>Abrir Matlab con permisos de administrador (run as administrator)
	>Abrir el script "run_fcd_maps.m"
	>Solo si es necesario, modificar los "CONFIGURATION PARAMETERS" (recomendado dejar en default)
	>Correr el script "run_fcd_maps.m"
	>Primero se solicita seleccionar cada una de las imagenes nifti de los controles originales (en espacio nativo)
	>Segundo se solicita seleccionar cada uno de las las imágenes de los pacientes originales (en espacio nativo) a los cuales se les quiere generar los mapas
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
		(p0*) Cerebro completo segmentado en espacio nativo
		(yi_*) Matriz de deformación para convertir del espacio del template al nativo