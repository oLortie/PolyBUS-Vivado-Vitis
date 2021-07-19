PolyBUS



****INFORMATION POUR GENERER LE PROJET VIVADO A PARTIR DES TCL*****
1. Ouvrir Vivado
2. Aller dans la console TCL et s'assurer d'être dans le bon folder ( .../PolyBUS/scripts) 
3. Exécuter la commande suivante : source ./PolyBUS.tcl


****INFORMATION POUR GENERER LE FICHIER myProgram.vhd POUR PICOBLAZE A PARTIR DU CODE ASSEMBLEUR KCPSM6*****
1. Modifier myProgram.psm
2. Compiler avec kcpsm6.exe qui donnera myProgram.vhd
3. Ajouter myProgram.vhd au projet Vivado s'il ne l'est pas déjà


**INFORMATION POUR GÉNÉRER LE PROJET VITIS À PARTIR DU TCL**
1. S'assurer que le xsa a été généré à partir de Vivado
2. Changer les paramètres du script tcl pour générer le projet au bon endroit
	2.1. Ouvrir le script tcl (scripts/vitisProj.tcl)
	2.2. Changer les lignes 11, 14 et 17 pour que les paths correspondent à votre ordinateur
	2.3. Ouvrir Xilinx software command line tool
	2.4. Exécuter la commande suivante :
		source D:/Git/PolyBUS/scripts/vitisProj.tcl (en changeant le path pour celui de votre ordinateur)
3. Ouvrir vitis dans le workspace PolyBUS/work/VitisWorkspace et s'assurer que le projet a bien été généré


**INFORMATION POUR SETUP DU SCRIPT DE GENERATION DE SIGNAUX**
1. Ouvrir une console de commande
2. Vérifier que Python est bien installé sur votre ordinateur avec la commande : python 
	Si Python est bien installé, il devrait vous afficher la version 
3. Installer pip si ce n'est pas deja fait
4. Installer le package neurokit2 : pip install neurokit2
	Normalement, tous les packages nécessaires sont installé avec neurokit2
5. Aller dans le répertoire PolyBUS/scripts
6. Exécuter la commande suivante pour vérifier que tous les packages nécéssaires sont installés :
	python SignalGenerator.py -h
7. Vous devriez voir un message d'aide qui vous montres quels paramètres peuvent être modifié

8. Vous être prêt a générer des signaux, voir la section suivante pour plus d'information sur les paramètres et les valeurs par défaut

9. Lors de l'exécution du script, un pop-up montre l'allure du signal demandé

10. Les échantillons VHDL sont inscrit de un fichier .txt dans le même répertoire que le script
Le nom du fichier va varier selon le signal choisi
Signalpo.txt pour un signal de pouls

**INFORMATION SUR LES PARAMÈTRES DU SCRIPT DE GÉNÉRATION DES SIGNAUX**** 
1. Le seul paramètre obligatoire a fournir est le type de signaux que l'on veut simuler
	1.1 Pour simuler un signal de Pouls , utiliser "po"
	1.2 Pour un signal de Pression artérielle : utiliser "pr"
	1.3 Pour un signal de respiration : utiliser "re"
	1.4 Pour un signal de perspiration : utiliser "re"
	Ce paramètre est inscrit directement après le .py dans la ligne de commande
	exemple : python SignalGenerator.py "po"  
	Cette ligne va générer un signal représentant le pouls avec les valeurs par défaut (signal d'une durée de 1 seconde a 70 Bpm)

2. Le paramètre -t représente la durée du signal simulé en seconde et indirectement le nombre d'échantillons total inscrit de le fichier .txt ** type int**
	valeur par défaut : 1 seconde
3. Le paramètre -f représente la fréquence d'échantillonnage de nos modules ADC/DAC en Hz **type int**
	valeur par défaut : 100Hz
4. Le paramètre -b représente le nombre de battement par minute ** type int**
	valeur par défaut : 70 bpm
	Ce paramètre est utilisé lors de la génération d'un signal de pouls et d'un signal de pression artérielle
5. Le paramètre -r représente la fréquence (Hz) du sinus de la respiration ** type float** 
	valeur par défaut : 0.25 
6. Les paramètres -S et -D sont la systolique et Diastolique respectivement **  type int **
	***Le maximum convenu est, de 140 pour la systolique  et de 90 pour la diastolique.**
	***Si vous entrez des valeurs supérieures, ca va faire chier les échantillons VHDL car certains vont dépasser 3.3 V et ne seront plus sur 12 bit***
	valeur par défaut : 120 et 80
7. Les paramètres -p, -s  et -pa sont liés au signal de perspiration ** type float, int et float respectivement**
	-p indique le taux de variation de la fonction 
	-s indique le nombre d'échantillons (step) que le signal va prendre pour varier d'un point a l'autre
	-pa indique l'amplitude de la perspiration. (valeur entre 0 et 1 qui représente le pourcentage de 3.3V)
	exemple -p =1  -s =3 -pa=0.5
	Le signal de perspiration va utiliser 3 échantillons pour passer de x a x +/- p/2 (valeur aléatoire entre +p/2 et -p/2) 
	Le signal restera toujours entre 0.9*pa*3.3 et 1.1*pa*3.3
	valeur par défaut : 1, 1 et 0.5 

8. Exemple de paramètre 

Pouls :  python SignalGenerator.py "po"  -t 5 -b 90 
	Génère un signal de  90 bpm pendant 5 seconde
Pression : python SignalGenerator.py "pr" -t 4 -S 110 -D 70
	Génère un signal avec 110 en systolique et 70 en diastolique a une fréquence de 70 bpm (valeur par défaut)
Respiration : python SignalGenerator.py "re" -t 6 -r 0.75 
	Génère un sinus a 0.75 Hz (1.3333333 respiration par seconde) pendant 
Perspiration : python SignalGenerator.py "pe" -p 0.5 -s 5 -pa 0.5
	Génère un signal qui débute aléatoirement entre 1.485 et 1,815 
	Le signal va varier de +/- 0.5 V à tous les 5 échantillons