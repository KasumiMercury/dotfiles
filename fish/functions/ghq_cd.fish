function ghq_cd --description 'cd into a ghq-managed repository selected with fzf'
    if not command -q ghq
        echo "ghq_cd: ghq is not installed" >&2
        return 1
    end
    if not command -q fzf
        echo "ghq_cd: fzf is not installed" >&2
        return 1
    end

    set -l ghq_root (ghq root)

    # GNU ls (Linux/coreutils) understands --color; BSD ls (macOS) does not,
    # and needs -G plus CLICOLOR_FORCE to colorize when stdout is not a tty.
    # fzf runs the preview command through $SHELL, so set the variable with
    # `env` rather than relying on a VAR=VALUE command prefix.
    set -l preview_cmd "env CLICOLOR_FORCE=1 ls -lA -G $ghq_root/{}"
    if command ls --color=always -d . >/dev/null 2>&1
        set preview_cmd "ls -lA --color=always $ghq_root/{}"
    end

    set -l selected (ghq list \
        | fzf \
            --prompt='ghq> ' \
            --preview "$preview_cmd" \
            --preview-window=right:60%:wrap \
            --ansi)

    if test -z "$selected"
        return 0
    end

    cd $ghq_root/$selected
end
