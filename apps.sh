#!/bin/bash

set -e

fish
read -p "Enter your username: " username

chsh -s /usr/bin/fish

echo
echo
echo "##################################################"
echo "###              SETUP GIT CRED                ###"
echo "##################################################"
echo
echo

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
echo "###            CONFIGURE FCITX                 ###"
echo "##################################################"
echo
echo

cat <<EOF > ~/.xprofile
# Fcitx5 input method
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
export INPUT_METHOD=fcitx
EOF

echo
echo
echo "##################################################"
echo "###            CONFIGURE FISH                  ###"
echo "##################################################"
echo
echo

cat <<EOF > ./fish/config.fish
if status is-interactive
    fastfetch
end

set -g fish_greeting
set -x DOTNET_CLI_TELEMETRY_OPTOUT 1
set -gx PATH \$PATH /home/$username/.dotnet/tools
EOF

mkdir -p ~/.config/fish
cp -frv ./fish/ ~/.config/fish/

echo
echo
echo "##################################################"
echo "###          CONFIGURE PLASMOIDS               ###"
echo "##################################################"
echo
echo

mkdir -p ~/.local/share/plasma/plasmoids/org.kde.plasma.taskmanager
cp -frv /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/ ~/.local/share/plasma/plasmoids/org.kde.plasma.taskmanager/
cp -fv ./plasmoids/org.kde.plasma.taskmanager/Task.qml ~/.local/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/ui/

mkdir -p ~/.icons
cp -frv ./cursors/* ~/.icons/

echo
echo
echo "##################################################"
echo "###          CONFIGURE KVANTUM                 ###"
echo "##################################################"
echo
echo

sudo cp -frv ./Kvantum/* /usr/share/Kvantum/

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
