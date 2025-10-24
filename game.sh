#!/bin/bash

set -e

echo
echo
echo "##################################################"
echo "###          INSTALL STEAM & APPS              ###"
echo "##################################################"
echo
echo

yay -S --noconfirm steam
yay -S --noconfirm protonup-qt gamemode mangohud lib32-mangohud dxvk-bin dxvk-async vkd3d-proton-bin
yay -S --noconfirm wine winetricks

# protonup-qt => để cài đặt
# thêm vào Properties của GAME: gamemoderun mangohud %command%

echo
echo "### INSTALLED APPS ###"
