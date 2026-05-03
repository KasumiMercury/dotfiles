git_root_cd() {
    if ! command -v git >/dev/null 2>&1; then
        echo "git_root_cd: git is not installed" >&2
        return 1
    fi

    local root
    root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [ -z "$root" ]; then
        echo "git_root_cd: not inside a git repository" >&2
        return 1
    fi

    cd "$root"
}
