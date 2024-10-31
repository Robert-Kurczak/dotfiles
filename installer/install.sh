#!/bin/bash

# ========= Options =========
opt_auto_confirm=false

while getopts ":y" opt; do
	case ${opt} in
		y )
			opt_auto_confirm=true
			;;
		\? )
			echo "Invalid option: -$OPTARG" >&2
			exit 1
			;;
	esac
done
# ===========================

# ======== Functions ========
can_place_file() {
	local file_path="$1"

	if sudo [ -e "$file_path" ] && [ "$opt_auto_confirm" = false ]; then
		read -p "File $file_path already exists. Do you want to replace it? (y/n): " choice
		choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')

		[[ "$choice" == "y" || "$choice" == "yes" ]]
		return
	fi

	true
}
# ===========================

# ========= Packages ========
source OFFICIAL_PACKAGES.sh
echo "Installing packages: ${OFFICIAL_PACKAGES[@]}"
sudo pacman -S ${OFFICIAL_PACKAGES[@]}

echo "Installing yay"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ../
rm -rf yay

source AUR_PACKAGES.sh
echo "Installing aur packages: ${AUR_PACKAGES[@]}"
yay -S ${AUR_PACKAGES[@]}
# ===========================

nvidia_installed=false
# ========= Nvidia =========
read -p "Do you want to install Nvidia drivers? (y/n): " choice
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
if [[ "$choice" == "y" || "$choice" == "yes" ]]; then
	echo "Installing Nvidia drivers. May God have mercy"
	sudo ./install-nvidia-drivers.sh
	nvidia_installed=true
fi
# ===========================

# ========= Configs =========
# grub
if ! $nvidia_installed; then
	source_grub_path="$HOME/.config/grub/grub"
	destination_grub_path="/etc/default/grub"

	if can_place_file $destination_grub_path; then
		sudo cp -f $source_grub_path $destination_grub_path
	fi
fi

source_grub_theme_path="$HOME/.config/grub/catppuccin-mocha-grub-theme/"
destination_grub_theme_path="/usr/share/grub/themes/catppuccin-mocha-grub-theme"

if can_place_file $destination_grub_theme_path; then
	sudo cp -rf $source_grub_theme_path $destination_grub_theme_path
	sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

# bluetooth
source_polkit_blueman_rules_path="$HOME/.config/polkit-rules/51-blueman.rules"
destination_polkit_blueman_rules_path="/etc/polkit-1/rules.d/51-blueman.rules"

if can_place_file $destination_polkit_blueman_rules_path; then
	sudo cp -f $source_polkit_blueman_rules_path $destination_polkit_blueman_rules_path
	sudo usermod -aG lp $USER
	sudo systemctl enable bluetooth.service
fi

# printer
sudo systemctl enable cups.service
sudo systemctl enable avahi-daemon.service

source_nsswitch_path="$HOME/.config/nsswitch.conf"
destination_nsswitch_path="/etc/nsswitch.conf"

if can_place_file $destination_nsswitch_path; then
	sudo cp -f $source_nsswitch_path $destination_nsswitch_path
	sudo systemctl restart cups.service
fi

# bashrc
source_bashrc_path="$HOME/.config/bash/.bashrc"
destination_bashrc_path="$HOME/.bashrc"

if can_place_file $destination_bashrc_path; then
	ln -sf $source_bashrc_path $destination_bashrc_path
fi

# eye of GNOME
xdg-mime default org.gnome.eog.desktop image/jpg
xdg-mime default org.gnome.eog.desktop image/jpeg
xdg-mime default org.gnome.eog.desktop image/png

# GTK
gsettings set org.gnome.desktop.wm.preferences button-layout :

# hyprshot
mkdir -p $HOME/Pictures/Screenshots
# ===========================
