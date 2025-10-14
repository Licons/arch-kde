#!/bin/bash

set -e

yay -S --noconfirm steam
yay -S --noconfirm protonup-qt gamemode mangohud lib32-mangohud dxvk-bin dxvk-async vkd3d-proton-bin
yay -S --noconfirm wine winestricks

#mkdir -p ~/.steam/root/compatibilitytools.d
#protonup-qt
# thêm vào Properties của GAME: gamemoderun mangohud %command%

echo "Hoàn tất cài đặt!"
