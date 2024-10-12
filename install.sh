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
REQUIRED_PACKAGES=(
	"hyprland"
	"alacritty"
	"waybar"
	"swaync"
	"udiskie"
	"fuzzel"
	"yazi"
	"vim"
	"feh"
	"ttf-sourcecodepro-nerd"
	"pipewire"
	"pipewire-pulse"
	"wireplumber"
	"xdg-desktop-portal-hyprland"
	"bluez"
	"bluez-utils"
	"bluez-obex"
	"cups"
	"cups-pdf"
	"avahi"
	"nss-mdns"
	"system-config-printer"
	"sane-airscan"
	"simple-scan"
	"nwg-displays"
)

REQUIRED_AUR_PACKAGES=(
	"brother-dcp1610w"	
)

echo "Installing packages: ${REQUIRED_PACKAGES[@]}"

sudo pacman -S ${REQUIRED_PACKAGES[@]}
# ===========================

# ========= Configs =========
# bashrc
source_bashrc_path="$HOME/.config/bash/.bashrc"
destination_bashrc_path="$HOME/.bashrc"

if can_place_file $destination_bashrc_path; then
	ln -sf $source_bashrc_path $destination_bashrc_path
fi

# grub
source_grub_path="$HOME/.config/grub/grub"
destination_grub_path="/etc/default/grub"

if can_place_file $destination_grub_path; then
	sudo cp $source_grub_path $destination_grub_path
fi

source_grub_theme_path="$HOME/.config/grub/catppuccin-mocha-grub-theme/"
destination_grub_theme_path="/usr/share/grub/themes/catppuccin-mocha-grub-theme"

if can_place_file $destination_grub_theme_path; then
	sudo cp -r $source_grub_theme_path $destination_grub_theme_path
	sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

# feh
source_feh_desktop_path="$HOME/.config/feh/feh.desktop"
destination_feh_desktop_path="/usr/share/applications/feh.desktop"

if can_place_file $destination_feh_desktop_path; then
	sudo ln -sf $source_feh_desktop_path $destination_feh_desktop_path
fi

# udev wakeup rules
source_udev_wakeup_rules_path="$HOME/.config/udev-rules/99-wake-on-device.rules"
destination_udev_wakeup_rules_path="/etc/udev/rules.d/99-wake-on-device.rules"

if can_place_file $destination_udev_wakeup_rules_path; then
	sudo ln -sf $source_udev_wakeup_rules_path $destination_udev_wakeup_rules_path
	sudo udevadm control -R
fi

# bluetooth
source_polkit_blueman_rules_path="$HOME/.config/polkit-rules/51-blueman.rules"
destination_polkit_blueman_rules_path="/etc/polkit-1/rules.d/51-blueman.rules"

if can_place_file $destination_polkit_blueman_rules_path; then
	sudo ln -sf $source_polkit_blueman_rules_path $destination_polkit_blueman_rules_path
	sudo usermod -aG lp $USER
	sudo systemctl enable bluetooth.service
fi

# printer
sudo systemctl enable cups.service
sudo systemctl enable avahi-daemon.service

source_nsswitch_path="$HOME/.config/nsswitch.conf"
destination_nsswitch_path="/etc/nsswitch.conf"

if can_place_file $destination_nsswitch_path; then
	sudo ln -sf $source_nsswitch_path $destination_nsswitch_path
	sudo systemctl restart cups.service
fi
# ===========================
