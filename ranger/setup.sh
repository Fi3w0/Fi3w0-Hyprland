#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RANGER_CONFIG="$HOME/.config/ranger"

if ! command -v ranger &>/dev/null; then
    echo "ranger not found, installing..."
    sudo pacman -S --noconfirm ranger
fi

if [ -d "$RANGER_CONFIG" ] && [ "$(ls -A "$RANGER_CONFIG")" ]; then
    BACKUP="$HOME/.config/ranger.backup.$(date +%s)"
    echo "existing config found, backing up to $BACKUP"
    mv "$RANGER_CONFIG" "$BACKUP"
fi

mkdir -p "$RANGER_CONFIG"
cp -r "$SCRIPT_DIR"/. "$RANGER_CONFIG/"
rm -f "$RANGER_CONFIG/setup.sh"

echo "ranger config installed to $RANGER_CONFIG"
