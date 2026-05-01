#!/usr/bin/env bash
set -ue

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DOT_DIR=$(dirname ${SCRIPT_DIR})

source "$DOT_DIR/.bin/link.sh"

DIR_NAME=$(basename $SCRIPT_DIR)

SRC="$SCRIPT_DIR/.gitconfig"

case "$ENVIRONMENT" in
	"windows")
		DEST="$HOME/.gitconfig"
		;;
	"linux")
		if command -v nix >/dev/null 2>&1; then
			echo "[$DIR_NAME] nix detected, skipping (use home-manager.sh for git config)"
			return 0
		fi
		DEST="$HOME/.config/git/config"
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

echo "[$DIR_NAME] install completed"
