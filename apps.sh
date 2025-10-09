#!/bin/bash

set -e

read -p "Enter your username: " username
chsh -s /usr/bin/fish

git config --global credential.helper store
cat <<EOF > ~/.git-credentials
https://TripOTAEcoSys@dev.azure.com
https://licons@github.com
EOF

cd /tmp
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si --noconfirm

# Cập nhật hệ thống
cd /tmp/arch-kde
yay -Syu --noconfirm

# Cài các phần mềm khác
echo "==> Cài đặt phần mềm"
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

echo "==> Cấu hình fcitx5 trong ~/.xprofile"
if ! grep -q "GTK_IM_MODULE=fcitx" ~/.xprofile 2>/dev/null; then
cat << 'EOF' >> ~/.xprofile
# Fcitx5 input method
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
export INPUT_METHOD=fcitx
EOF
fi

echo "Copy cấu hình Fish"
cat <<EOF > ~/.config/fish/config.fish
if status is-interactive
    fastfetch
end

set -g fish_greeting
set -x DOTNET_CLI_TELEMETRY_OPTOUT 1
set -gx PATH \$PATH /home/$username/.dotnet/tools
EOF
mkdir -p ~/.config/fish/functions
cat <<EOF > ~/.config/fish/functions/fish_prompt.fish
function fish_prompt
    set_color cyan
    echo (pwd)
    set_color green
    echo -n '> '
    set_color normal
end
EOF

echo "Copy widgets"
cp -frv /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/ ~/.local/share/plasma/plasmoids/org.kde.plasma.taskmanager/
cp -fv ./widgets/org.kde.plasma.taskmanager/Task.qml ~/.local/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/ui/
cp -frv ./cursors/* ~/.icons/

echo "Copy Kvantum"
sudo tar -xJf ./Kvantum/Layan.tar.xz -C /usr/share/Kvantum/
sudo tar -xJf ./Kvantum/Layan-solid.tar.xz -C /usr/share/Kvantum/
sudo tar -xJf ./Kvantum/Sweet.tar.xz -C /usr/share/Kvantum/
sudo tar -xJf ./Kvantum/Sweet-Ambar-Blue.tar.xz -C /usr/share/Kvantum/
sudo tar -xJf ./Kvantum/Sweet-Mars.tar.xz -C /usr/share/Kvantum/
sudo tar -xJf ./Kvantum/Sweet-Mars-transparent-toolbar.tar.xz -C /usr/share/Kvantum/
sudo tar -xJf ./Kvantum/Sweet-transparent-toolbar.tar.xz -C /usr/share/Kvantum/

echo "==> Cài đặt DOTNET"
wget -P ~/Downloads https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.414/dotnet-sdk-8.0.414-linux-x64.tar.gz
sudo mkdir -p /usr/share/dotnet
sudo tar -xzf ~/Downloads/dotnet-sdk-8.0.414-linux-x64.tar.gz -C /usr/share/dotnet/
sudo ln -sf /usr/share/dotnet/dotnet /usr/bin/dotnet

dotnet --info
# dotnet tool update -g linux-dev-certs
# dotnet linux-dev-certs install
dotnet dev-certs https --trust

dotnet tool install -g dotnet-ef
dotnet tool install -g dotnet-sonarscanner

sudo npm i -g bash-language-server
sudo npm i -g @openapitools/openapi-generator-cli
sudo openapi-generator-cli version-manager set 7.14.0

echo "Hoàn tất cài đặt Ứng dụng!"
