#!/usr/bin/env bash
set -ue

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DOT_DIR=$(dirname ${SCRIPT_DIR})

source "$DOT_DIR/.bin/link.sh"

DIR_NAME=$(basename $SCRIPT_DIR)

SRC_DIR=$SCRIPT_DIR/.ideavimrc

IS_INSTALL=1

case "$ENVIRONMENT" in
	"windows")
		DEST_DIR="$HOME/.ideavimrc"
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

	if ! link_dir "$SRC_DIR" "$DEST_DIR"; then
		echo "failed to create symbolic link"
		exit 1
	fi

	echo "[$DIR_NAME] install completed"
fi

