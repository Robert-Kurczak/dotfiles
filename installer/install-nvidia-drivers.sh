#!/bin/bash

DRIVERS_PACKAGES=(
    "linux-headers"                     # Required by dkms headers
    "nvidia-dkms"                       # Nvidia GPU drivers
    "nvidia-utils"                      # More Nvidia drivers
    "nvidia-settings"                   # GUI config utility
    "egl-wayland"                       # Wayland compatibility with EGL
)

sudo pacman -S ${DRIVERS_PACKAGES[@]}

source_mkinitcpio_path="$HOME/.config/mkinitcpio.conf"
destination_mkinitcpio_path="/etc/mkinitcpio.conf"

sudo cp -f $source_mkinitcpio_path $destination_mkinitcpio_path
sudo echo "options nvidia_drm modeset=1 fbdev=1" > /etc/modprobe.d/nvidia.conf

source_grub_path="$HOME/.config/grub/grub-nvidia"
destination_grub_path="/etc/default/grub"
sudo cp -f $source_grub_path $destination_grub_path

sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg