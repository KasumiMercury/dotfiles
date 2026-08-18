ghq_cd() {
    if ! command -v ghq >/dev/null 2>&1; then
        echo "ghq_cd: ghq is not installed" >&2
        return 1
    fi
    if ! command -v fzf >/dev/null 2>&1; then
        echo "ghq_cd: fzf is not installed" >&2
        return 1
    fi

    local ghq_root selected preview_cmd
    ghq_root=$(ghq root)

    # GNU ls (Linux/coreutils) understands --color; BSD ls (macOS) does not,
    # and needs -G plus CLICOLOR_FORCE to colorize when stdout is not a tty.
    # fzf runs the preview command through $SHELL, so set the variable with
    # `env` rather than relying on a VAR=VALUE command prefix.
    if command ls --color=always -d . >/dev/null 2>&1; then
        preview_cmd="ls -lA --color=always $ghq_root/{}"
    else
        preview_cmd="env CLICOLOR_FORCE=1 ls -lA -G $ghq_root/{}"
    fi

    selected=$(ghq list \
        | fzf \
            --prompt='ghq> ' \
            --preview "$preview_cmd" \
            --preview-window=right:60%:wrap \
            --ansi)

    if [ -z "$selected" ]; then
        return 0
    fi

    cd "$ghq_root/$selected"
}
