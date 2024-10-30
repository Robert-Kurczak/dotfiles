#!/bin/bash

DRIVERS_PACKAGES=(
    "nvidia-dkms"                       # Nvidia GPU drivers
    "nvidia-utils"                      # More Nvidia drivers
    "egl-wayland"                       # Wayland compatibility with EGL
)

sudo pacman -S ${DRIVERS_PACKAGES[@]}

new_modules=("nvidia nvidia_modeset nvidia_uvm nvidia_drm")
# Add modules to mkinitcpio modules array
sudo sed -i -E "/^MODULES=\(.*\)/ {s/\)/ ${new_modules[@]} &/}" /etc/mkinitcpio.conf
sudo echo "options nvidia_drm modeset=1 fbdev=1" > /etc/modprobe.d/nvidia.conf
sudo mkinitcpio -P