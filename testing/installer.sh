#!/bin/bash

# Paths for the script to be installed into
scriptPath="/home/$USER/.local/share/mcmgr/"
configPath="/home/$USER/.config/mcmgr/"
binPath="/usr/local/bin/"

# Temporary path to download the necessary files
# So they can be moved to the correct directories
tempDownloadPath="/home/$USER/mcmgr-temp"

echo "Instaling mcmgr..."

echo "Creating directory: $scriptPath"
mkdir $scriptPath
echo "Creating directory: $configPath"
mkdir $configPath

echo "Creating temporary directory for download: $tempDownloadPath"
mkdir $tempDownloadPath
cd $tempDownloadPath

echo "Cloning git repo into $PWD"
git clone "https://github.com/AndrejPatak/mcmgr.git"

cd ./mcmgr
rm -rf ./testing

mv ./LICENSE $scriptPath
mv ./README.md $scriptPath
mv ./minecraft-manager.sh $scriptPath

cd ..
rm -rf ./mcmgr
cd ..
rm -rf $tempDownloadPath

sudo ln -s "$scriptPath"minecraft-manager.sh /usr/local/bin/mcmgr
