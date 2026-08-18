#!/usr/bin/env bash
set -ue

helpmsg() {
	command echo "Usage: $0 [--help | -h]" 0>&2
	command echo ""
}

detect_environment() {
	case "$OSTYPE" in
		msys* | cygwin*)
			echo "windows"
			;;
		darwin*)
			echo "darwin"
			;;
		*)
			echo "linux"
			;;
	esac
}

link_dots() {
	local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
	local dot_dir=$(dirname ${script_dir})

	ENVIRONMENT=$(detect_environment)
	echo "Environment: $ENVIRONMENT"
	
	local answer
	read -p "Is correct? (y/N): " answer

	# NOTE: lowercase via tr for macOS system bash (3.2), which lacks the
	# bash 4 lowercasing parameter expansion
	answer=$(printf '%s' "$answer" | tr '[:upper:]' '[:lower:]')

	if [ "$answer" != "y" ];then
		return 1
	fi

	for dir in $dot_dir/*/;do
		echo "=== run $dir install ==="
		[[ `basename $dir` == ".git" ]] && continue
		[[ `basename $dir` == ".bin" ]] && continue

		if [ -f "$dir/install.sh" ];then
			cd "$dir"

			source "./install.sh"

			cd ..
			
			echo "=== completed $dir install ==="
			echo
		else
			echo "Not found install.sh in $dir"
		fi
	done
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
command echo -e "\033[1;36m Install completed!!!! \033[m"

