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

	if [[ "$opt_auto_confirm" = false && -e "$file_path" ]]; then
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
	"dunst"
	"fuzzel"
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
fi

sudo grub-mkconfig -o /boot/grub/grub.cfg
# ===========================