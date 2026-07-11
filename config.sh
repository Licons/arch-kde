#!/bin/bash

set -e

chsh -s /usr/bin/fish $USER


echo
echo
echo "##################################################"
echo "###          CONFIGURE THEMES                  ###"
echo "##################################################"
echo
echo

mkdir -p ~/.icons
cp -frv ./icons/* ~/.icons/

mkdir -p ~/.themes
cp -frv ./themes/* ~/.themes/

mkdir -p ~/.local
cp -frv ./local/* ~/.local/

mkdir -p ~/.config
cp -frv ./config/* ~/.config/


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

mkdir -p ~/.config/environment.d
cat <<EOF > ~/.config/environment.d/im.conf
# Fcitx5 input method
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
INPUT_METHOD=fcitx
EOF


echo
echo
echo "##################################################"
echo "###             CONFIGURE GIT                  ###"
echo "##################################################"
echo
echo

cat <<EOF > ~/.gitconfig
[user]
	name = Licons Chou
	email = liconschou@gmail.com
[credential]
	helper = store
[core]
	autocrlf = input
[filter "lfs"]
	smudge = git-lfs smudge -- %f
	process = git-lfs filter-process
	required = true
	clean = git-lfs clean -- %f
EOF

cat <<EOF > ~/.git-credentials
https://TripOTAEcoSys@dev.azure.com
https://licons@github.com
EOF

#echo
#echo
#echo "##################################################"
#echo "###          CONFIGURE MANGOHUD                ###"
#echo "##################################################"
#echo
#echo
#
#mkdir -p ~/.config/environment.d
#echo "MANGOHUD=1">~/.config/environment.d/mangohud.conf
#
#mkdir -p ~/.config/MangoHud
#cat <<EOF > ~/.config/MangoHud/MangoHud.conf
#legacy_layout=false
#position=top-right
#
#fps
#cpu_stats
#gpu_stats
#cpu_temp
#gpu_temp
#EOF

echo
echo
echo "##################################################"
echo "###          CONFIGURE UFW                     ###"
echo "##################################################"
echo
echo

sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw allow Samba
sudo ufw allow 9000/tcp
sudo ufw enable

echo
echo "### DONE ###"

reboot
