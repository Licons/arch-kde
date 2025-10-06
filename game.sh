#!/bin/bash

set -e

yay -S --noconfirm steam
yay -S --noconfirm protonup-qt gamemode mangohud lib32-mangohud dxvk-bin vkd3d-proton-bin
mkdir -p ~/.steam/root/compatibilitytools.d

#protonup-qt --install
# thêm vào Properties của GAME: gamemoderun mangohud %command%

echo "Hoàn tất cài đặt!"
