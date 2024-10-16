#!/usr/bin/env bash
set -ue

helpmsg() {
	command ehco "Usage: $0 [--help | -h]" 0>&2
	command echo ""
}

link_dots() {
	command echo "buckup old dotfiles..."
	if [ ! -d "$HOME/.dotbackup" ];then
		command echo "$HOME/.dotbackup not found. Auto Make it"
		command mkdir "$HOME/.dotbackup"
	fi

	local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
	local dot_dir=$(dirname ${script_dir})

	if [[ "$HOME" != "$dot_dir" ]];then
		local config_file="$script_dir/link_config.txt"

		if [[ -f "$config_file" ]];then
			while IFS=, read -r src dest; do
				src="$dot_dir/$src"
				dest="$HOME/$dest"
				link_dir "$src" "$dest"
			done < "$config_file"
		fi

		for f in $dot_dir/.??*;do
			[[ `basename $f` == ".git" ]] && continue
			[[ `basename $f` == ".bin" ]] && continue

			if ! grep -q "^$(basename $f),""$config_file" 2>/dev/null;then
				link_dir "$f" "$HOME/$(basename $f)"
			fi
		done
	else
		command echo "same install src dest"
	fi
}

while [ $# -gt 0 ];do
	case ${1} in
		--debug| -d)
			set -uex
			;;
		--help | -h)
			helpmsg
			exit 1
			;;
		*)
			;;
	esac
	shift
done

link_dots
command echo -e "\e[1;36m Install completed!!!! \e[m"

