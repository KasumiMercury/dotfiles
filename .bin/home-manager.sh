#!/usr/bin/env bash
set -ue

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd -P)"
DOT_DIR="$(dirname "$SCRIPT_DIR")"
HM_CONFIG_DIR="$HOME/.config/home-manager"

echo "=== home-manager config setup ==="
echo "Source: $DOT_DIR/home-manager/home.nix"
echo "Dest:   $HM_CONFIG_DIR/home.nix"

# Ensure target directory exists
mkdir -p "$HM_CONFIG_DIR"

# Backup existing file if it's not already a symlink
if [ -e "$HM_CONFIG_DIR/home.nix" ] && [ ! -L "$HM_CONFIG_DIR/home.nix" ]; then
    BACKUP="$HM_CONFIG_DIR/home.nix.dotbackup-$(date +%Y%m%d-%H%M%S)"
    echo "Backing up existing home.nix -> $BACKUP"
    mv "$HM_CONFIG_DIR/home.nix" "$BACKUP"
elif [ -L "$HM_CONFIG_DIR/home.nix" ]; then
    rm -f "$HM_CONFIG_DIR/home.nix"
fi

ln -snf "$DOT_DIR/home-manager/home.nix" "$HM_CONFIG_DIR/home.nix"
echo "Linked: $DOT_DIR/home-manager/home.nix -> $HM_CONFIG_DIR/home.nix"

echo ""
echo "Run 'home-manager switch' to apply the configuration."
echo -e "\e[1;36m home-manager setup completed! \e[m"
