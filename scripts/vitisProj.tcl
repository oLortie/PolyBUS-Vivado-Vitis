# 
# Pour lancer : 
# Ouvrir "Xilinx Software Command Line Tool 2020.2" (XSCT)
# Lancer le script avec la commande suivante: 
#		source D:/ZYBO/Work-2020.2/Ateliers/Atelier2-Git/scripts/atelier2_vitisProj.tcl

# nom du projet
set app_name PolyBUS

# spécifier le répertoire où placer le projet
set workspace D:/Git/PolyBUS/work/VitisWorkspace

# Paths pour les fichiers sources c/c++/h
set sourcePath D:/Git/PolyBUS/vitisProj

# Path pour le fichier .xsa
set xsa_file D:/Git/PolyBUS/work/PolyBUS/PolyBUSHardware.xsa

set platform_name  design_1_wrapper

# Créer le workspace
file delete -force $workspace
setws $workspace
cd $workspace

# create platform 
platform create -name $platform_name -hw $xsa_file -no-boot-bsp

# add freertos domain
domain create -name FreeRTOS_domain -os freertos10_xilinx -proc ps7_cortexa9_0

# change FreeRTOS BSP settings"
bsp setlib -name lwip211
bsp config api_mode SOCKET_API
platform write
bsp config dhcp_does_arp_check true
platform write
bsp config lwip_dhcp true
platform write
bsp config pbuf_pool_size 2048
platform write

bsp setlib -name xilffs
bsp config use_lfn 1
platform write

bsp regenerate

platform generate

# Créer le projet. La plateform va être créée automatiquement par XSCT
app create -name $app_name -platform $platform_name -domain FreeRTOS_domain -template {Empty Application} 

# Importation des fichiers sources
importsources -name $app_name -path $sourcePath -soft-link
importsources -name $app_name -path $sourcePath/lscript.ld -linker-script

platform clean

platform generate 

# Compiler le projet
app build -name $app_name