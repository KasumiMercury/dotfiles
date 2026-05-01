function git_root_cd --description 'cd to the root of the current git repository'
    if not command -q git
        echo "git_root_cd: git is not installed" >&2
        return 1
    end

    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    if test -z "$root"
        echo "git_root_cd: not inside a git repository" >&2
        return 1
    end

    cd $root
end
