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

source_bashrc_path="$HOME/.config/bash/.bashrc"
destination_bashrc_path="$HOME/.bashrc"

if can_place_file $destination_bashrc_path; then
    ln -sf $source_bashrc_path $destination_bashrc_path
fi