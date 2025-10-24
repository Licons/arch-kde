#!/bin/bash

set -e

read -p "Enter your username: " username

chsh -s /usr/bin/fish

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
cp -frv ./fish/* ~/.config/fish/

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
echo "###          CONFIGURE GIT CRED                ###"
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
echo "###          CONFIGURE PLASMOIDS               ###"
echo "##################################################"
echo
echo

mkdir -p ~/.local/share/plasma/plasmoids/org.kde.plasma.taskmanager/
cp -frv /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/* ~/.local/share/plasma/plasmoids/org.kde.plasma.taskmanager/
cp -fv ./plasmoids/org.kde.plasma.taskmanager/Task.qml ~/.local/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/ui/Task.qml

echo
echo
echo "##################################################"
echo "###          CONFIGURE THEMES                  ###"
echo "##################################################"
echo
echo

mkdir -p ~/.icons
cp -frv ./cursors/* ~/.icons/

mkdir -p ~/.themes
cp -frv ./themes/* ~/.themes/

echo
echo
echo "##################################################"
echo "###          CONFIGURE KVANTUM                 ###"
echo "##################################################"
echo
echo

sudo cp -frv ./Kvantum/* /usr/share/Kvantum/

echo
echo "### DONE ###"
