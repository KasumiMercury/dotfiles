#!/usr/bin/env bash
set -ue

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DOT_DIR=$(dirname ${SCRIPT_DIR})

source "$DOT_DIR/.bin/link.sh"

DIR_NAME=$(basename $SCRIPT_DIR)

SRC="$SCRIPT_DIR/.zshrc"

case "$ENVIRONMENT" in
	"windows")
		echo "[$DIR_NAME] zsh is not supported on Windows, skipping"
		return 0
		;;
	"linux")
		DEST="$HOME/.zshrc"
		;;
	*)
		echo "undefined: $ENVIRONMENT"
		exit 1
		;;
esac

echo "[$DIR_NAME] install"

if ! link_dir "$SRC" "$DEST"; then
	echo "failed to create symbolic link"
	exit 1
fi

LOCAL_DIR="$HOME/.config/zsh"
LOCAL_FILE="$LOCAL_DIR/local.zshrc"
if [ ! -e "$LOCAL_FILE" ]; then
	mkdir -p "$LOCAL_DIR"
	cat > "$LOCAL_FILE" <<'EOF'
# PC-specific zsh configuration.
# This file is sourced from the managed ~/.zshrc but is NOT tracked by dotfiles.
# Add machine-local settings (PATH tweaks, work-only aliases, secrets, etc.) here.
EOF
	echo "Created local config: $LOCAL_FILE"
fi

echo "[$DIR_NAME] install completed"
