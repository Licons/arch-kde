#!/bin/bash

set -e

echo
echo
echo "##################################################"
echo "###              SETUP GIT CRED                ###"
echo "##################################################"
echo
echo

git config --global user.name "Licons Chou"
git config --global user.email "liconschou@gmail.com"
git config --global credential.helper store
cat <<EOF > ~/.git-credentials
https://TripOTAEcoSys@dev.azure.com
https://licons@github.com
EOF

echo
echo
echo "##################################################"
echo "###                SETUP YAY                   ###"
echo "##################################################"
echo
echo

cd /tmp
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si --noconfirm

echo
echo
echo "##################################################"
echo "###              UPDATE BY YAY                 ###"
echo "##################################################"
echo
echo

cd /tmp/arch-kde
yay -Syu --noconfirm

echo
echo
echo "##################################################"
echo "###              INSTALL APPS                  ###"
echo "##################################################"
echo
echo

yay -S --noconfirm \
  kf6-servicemenus-rootactions \
  zen-browser-bin vlc \
  libreoffice-fresh \
  nodejs npm jdk-openjdk \
  onedrive onedrivegui teams-for-linux \
  rider dbeaver postman-bin \
  appimagelauncher \
  rclone \
  ttf-ms-fonts

echo
echo
echo "##################################################"
echo "###          INSTALL DOTNET 8+9                ###"
echo "##################################################"
echo
echo

wget -P ~/Downloads https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.415/dotnet-sdk-8.0.415-linux-x64.tar.gz
wget -P ~/Downloads https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.306/dotnet-sdk-9.0.306-linux-x64.tar.gz

sudo mkdir -p /usr/share/dotnet
sudo tar -xzf ~/Downloads/dotnet-sdk-8.0.415-linux-x64.tar.gz -C /usr/share/dotnet/
sudo tar -xzf ~/Downloads/dotnet-sdk-9.0.306-linux-x64.tar.gz -C /usr/share/dotnet/
sudo ln -sf /usr/share/dotnet/dotnet /usr/bin/dotnet

dotnet --info
dotnet tool update -g linux-dev-certs
dotnet linux-dev-certs install
dotnet dev-certs https --trust

dotnet tool install -g dotnet-ef
dotnet tool install -g dotnet-sonarscanner

echo
echo
echo "##################################################"
echo "###          INSTALL NPM PACKAGE               ###"
echo "##################################################"
echo
echo

sudo npm i -g bash-language-server
sudo npm i -g @openapitools/openapi-generator-cli
sudo openapi-generator-cli version-manager set 7.14.0

echo
echo
echo "##################################################"
echo "###        DOWNLOAD ANOTHER REDIS              ###"
echo "##################################################"
echo
echo

wget -P ~/Downloads https://github.com/qishibo/AnotherRedisDesktopManager/releases/download/v1.7.1/Another-Redis-Desktop-Manager-linux-1.7.1-x86_64.AppImage

echo
echo "### INSTALLED APPS ###"
