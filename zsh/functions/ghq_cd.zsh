ghq_cd() {
    if ! command -v ghq >/dev/null 2>&1; then
        echo "ghq_cd: ghq is not installed" >&2
        return 1
    fi
    if ! command -v fzf >/dev/null 2>&1; then
        echo "ghq_cd: fzf is not installed" >&2
        return 1
    fi

    local ghq_root selected
    ghq_root=$(ghq root)
    selected=$(ghq list \
        | fzf \
            --prompt='ghq> ' \
            --preview "ls -lA --color=always $ghq_root/{}" \
            --preview-window=right:60%:wrap \
            --ansi)

    if [ -z "$selected" ]; then
        return 0
    fi

    cd "$ghq_root/$selected"
}
