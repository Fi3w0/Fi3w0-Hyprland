#!/usr/bin/env bash
# ~/install_apps.sh
# Installs all apps from list.txt (pacman + AUR)

set -euo pipefail

LIST_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/list.txt"

echo "🚀 Starting app installation..."

# Update package databases
sudo pacman -Sy --noconfirm

# Ensure yay exists for AUR packages
if ! command -v yay &>/dev/null; then
    echo "📦 Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd ~
fi

# Read package list, skip comments/empty lines
ALL_PACKAGES=$(grep -v '^#' "$LIST_PATH" | sed '/^\s*$/d')

PACMAN_PKGS=""
AUR_PKGS=""

# Separate official repo vs AUR packages
for pkg in $ALL_PACKAGES; do
    if pacman -Si "$pkg" &>/dev/null; then
        PACMAN_PKGS+="$pkg "
    else
        AUR_PKGS+="$pkg "
    fi
done

# Install official repo packages
if [ -n "$PACMAN_PKGS" ]; then
    echo "📦 Installing official packages..."
    sudo pacman -S --needed --noconfirm $PACMAN_PKGS
fi

# Install AUR packages
if [ -n "$AUR_PKGS" ]; then
    echo "🧩 Installing AUR packages..."
    yay -S --needed --noconfirm $AUR_PKGS
fi

echo "✅ All packages installed!"
