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
    set -l selected (ghq list \
        | fzf \
            --prompt='ghq> ' \
            --preview "ls -lA --color=always $ghq_root/{}" \
            --preview-window=right:60%:wrap \
            --ansi)

    if test -z "$selected"
        return 0
    end

    cd $ghq_root/$selected
end
