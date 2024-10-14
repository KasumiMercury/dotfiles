#!/usr/bin/env bash
set -ue

helpmsg() {
	command ehco "Usage: $0 [--help | -h]" 0>&2
	command echo ""
}

link_dir() {
	command echo "buckup old dotfiles..."
	if [ ! -d "$HOME/.dotbackup" ];then
		command echo "$HOME/.dotbackup not found. Auto Make it"
		command mkdir "$HOME/.dotbackup"
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

link_dir
command echo -e "\e[1;36m Install completed!!!! \e[m"

