#!/bin/bash
set -e

echo "==> Setup timezone"
ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
timedatectl set-timezone Asia/Ho_Chi_Minh
timedatectl set-ntp true

echo "==> Configure locale"
if ! grep -q "en_US.UTF-8 UTF-8" /etc/locale.gen; then
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
fi
locale-gen
if ! grep -q "LANG=en_US.UTF-8" /etc/locale.conf; then
    echo "LANG=en_US.UTF-8" > /etc/locale.conf
fi

read -p "Enter your hostname: " hostname
echo "==> Hostname"
echo "$hostname" > /etc/hostname
if ! grep -q "127.0.0.1 $hostname.localdomain $hostname" /etc/hosts; then
    echo "127.0.0.1 $hostname.localdomain $hostname" >> /etc/hosts
fi

echo "==> Setup password for root"
passwd

read -p "Enter your username: " username
echo "==> Create and setup password for user: $username"
useradd -mG wheel "$username"
passwd "$username"

echo "==> Setup wheel"
EDITOR=nano visudo

echo "==> Update /etc/pacman.conf"
sed -i '/^\#\[multilib\]/{n;s/^#Include = \/etc\/pacman\.d\/mirrorlist/Include = \/etc\/pacman\.d\/mirrorlist/;s/^#//}' /etc/pacman.conf
sed -i 's/^#\[multilib\]/\[multilib\]/' /etc/pacman.conf

echo "==> Update system"
pacman -Syu --noconfirm

echo "==> Update /etc/mkinitcpio.d/linux.preset"
sed -i \
    -e "s|^PRESETS=('default' 'fallback')|PRESETS=('default')|" \
    -e 's|^fallback_image=|#fallback_image=|' \
    -e 's|^fallback_options=|#fallback_options=|' \
    /etc/mkinitcpio.d/linux.preset

rm -f /boot/initramfs-linux-fallback.img
mkinitcpio -P

echo "==> GRUB Install"
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB

echo "==> Install theme for GRUB"
cd /tmp
git clone https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes
./install.sh -t tela
cd /

echo "==> Update GRUB"
sed -i \
    -e "s|^GRUB_DEFAULT=.*|GRUB_DEFAULT=saved|" \
    -e "s|^GRUB_TIMEOUT=.*|GRUB_TIMEOUT=2|" \
    -e "s|^#GRUB_DISABLE_RECOVERY=.*|GRUB_DISABLE_RECOVERY=true|" \
    -e "s|^#GRUB_SAVEDEFAULT=.*|GRUB_SAVEDEFAULT=true|" \
    -e "s|^#GRUB_DISABLE_SUBMENU=.*|GRUB_DISABLE_SUBMENU=y|" \
    -e "s|^#GRUB_DISABLE_OS_PROBER=.*|GRUB_DISABLE_OS_PROBER=false|" \
    /etc/default/grub

chmod -x /etc/grub.d/30_uefi-firmware
grub-mkconfig -o /boot/grub/grub.cfg

echo "==> Install ArchLinux completed!"

echo

echo "==> Install NVIDIA driver"
pacman -S --noconfirm \
    nvidia-dkms nvidia-utils nvidia-settings \
    lib32-nvidia-utils vulkan-icd-loader lib32-vulkan-icd-loader

echo "options nvidia-drm modeset=1" > /etc/modprobe.d/nvidia.conf
echo "blacklist nouveau" > /etc/modprobe.d/blacklist-nouveau.conf

### ==== KDE ====
echo "==> Install KDE and Apps"
pacman -S --noconfirm \
    plasma-meta \
    sddm sddm-kcm \
    konsole dolphin dolphin-plugins spectacle ark gwenview kalk kate jq okular \
    flatpak pacman-contrib kvantum-qt5 system-config-printer \
    pipewire pipewire-audio pipewire-alsa pipewire-jack wireplumber \
    bluez bluez-utils bluedevil \
    powerdevil power-profiles-daemon \
    ufw ufw-extras \
    fastfetch fish wget curl unrar \
    fcitx5-im fcitx5-configtool fcitx5-unikey \
    ttf-roboto ttf-dejavu ttf-liberation ttf-jetbrains-mono \
    noto-fonts noto-fonts-cjk noto-fonts-emoji \
    docker docker-compose

systemctl enable sddm
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable ufw
systemctl enable systemd-timesyncd
systemctl enable docker
systemctl enable fstrim.timer

usermod -aG docker $username

echo "==> Install KDE and Apps completed!"
