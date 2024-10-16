#!/usr/bin/env bash
set -ue

backup() {
	local dest="$dest"
	if [ -e "$dest" ];then
		echo "backup $dest"
		mv "$dest" "${dest}.dotbackup-$(date +%Y%m%d-%h%M%S)"
		return 0
	fi
	return 1
}

link_dir() {
	local src="$1"
	local dest="$2"

	if [ -z "$src" ] || [ -z "$dest" ]; then
		echo "Error: Missing required argument for link_dir"
		return 1
	fi

	src=$(realpath "$src")

	echo "Make symbolic link: $src -> $dest"
	
	if [[ $ENVIRONMENT == "windows" ]];then
		export MSYS=winsymlinks:nativestrict
	fi

	if [[ -e "$src" ]];then
		if [[ -L "$dest" ]];then
			rm -f "$dest"
		elif [[ -e "$dest" ]];then
			backup $dest
		fi

		mkdir -p "$(dirname "$dest")"
		ln -snf "$src" "$dest"
		echo "Linked: $src -> $dest"
	fi
}

