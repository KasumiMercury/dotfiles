#!/usr/bin/env bash
set -ue

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DOT_DIR=$(dirname ${SCRIPT_DIR})

source "$DOT_DIR/.bin/link.sh"

DIR_NAME=$(basename $SCRIPT_DIR)

case "$ENVIRONMENT" in
	"windows")
		echo "[$DIR_NAME] fish is not supported on Windows, skipping"
		return 0
		;;
	"linux")
		DEST_DIR="$HOME/.config/fish/functions"
		;;
	*)
		echo "undefined: $ENVIRONMENT"
		exit 1
		;;
esac

echo "[$DIR_NAME] install"

mkdir -p "$DEST_DIR"

shopt -s nullglob
for src in "$SCRIPT_DIR/functions"/*.fish; do
	if ! link_dir "$src" "$DEST_DIR/$(basename "$src")"; then
		echo "failed to create symbolic link for $src"
		exit 1
	fi
done
shopt -u nullglob

echo "[$DIR_NAME] install completed"
