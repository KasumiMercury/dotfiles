#!/usr/bin/env bash
set -ue

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DOT_DIR=$(dirname ${SCRIPT_DIR})

source "$DOT_DIR/.bin/link.sh"

DIR_NAME=$(basename $SCRIPT_DIR)

SRC_DIR=$SCRIPT_DIR
case "$ENVIRONMENT" in
	"windows")
		;;
	"linux")
		DEST_DIR="$HOME/.config/nvim"
		;;
	*)
		echo "undefined: $ENVIRONMENT"
		exit 1
		;;
esac

echo "[$DIR_NAME] install"

if ! link_dir "$SRC_DIR" "$DEST_DIR"; then
	echo "failed to create symbolic link"
	exit 1
fi

echo "[$DIR_NAME] install completed"


