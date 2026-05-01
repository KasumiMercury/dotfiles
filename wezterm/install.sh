#!/usr/bin/env bash
set -ue

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DOT_DIR=$(dirname ${SCRIPT_DIR})

source "$DOT_DIR/.bin/link.sh"

DIR_NAME=$(basename $SCRIPT_DIR)

SRC_WEZTERM=$SCRIPT_DIR/.wezterm.lua
SRC_KEYMAPS=$SCRIPT_DIR/keymaps.lua

IS_INSTALL=1

case "$ENVIRONMENT" in
	"windows")
		DEST_WEZTERM="$HOME/.wezterm.lua"
		DEST_KEYMAPS="$HOME/keymaps.lua"
		;;
	"linux")
		IS_INSTALL=0
		;;
	*)
		echo "undefined: $ENVIRONMENT"
		exit 1
		;;
esac

if [ $IS_INSTALL -eq 1 ]; then
	echo "[$DIR_NAME] install"

	if ! link_dir "$SRC_WEZTERM" "$DEST_WEZTERM"; then
		echo "failed to create symbolic link"
		exit 1
	fi

	if ! link_dir "$SRC_KEYMAPS" "$DEST_KEYMAPS"; then
		echo "failed to create symbolic link"
		exit 1
	fi

	echo "[$DIR_NAME] install completed"
fi
