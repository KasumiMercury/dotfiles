!/usr/bin/env bash
set -ue

helpmsg() {
	command ehco "Usage: $0 [--help | -h]" 0>&2
	command echo ""
}

detect_environment() {
	if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]];then
		echo "windows"
	else
		echo "linux"
	fi
}

link_dots() {
	local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
	local dot_dir=$(dirname ${script_dir})

	ENVIRONMENT=$(detect_environment)
	echo "Environment: $ENVIRONMENT"
	
	read -p "Is correct? (y/N): " answer

	if [[ "${answer,,}" != "y" ]];then
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
command echo -e "\e[1;36m Install completed!!!! \e[m"

