# Emit OSC 7 so WezTerm can track the current working directory.
# Without this, `SpawnTab 'CurrentPaneDomain'` opens new tabs in the
# wezterm-gui process cwd (typically the Windows user home on WSL).
autoload -Uz add-zsh-hook

_wezterm_osc7_cwd() {
    local hostname="${HOST:-$(hostname)}"
    local strlen=${#PWD}
    local encoded="" pos c o
    for (( pos=0; pos<strlen; pos++ )); do
        c=${PWD:$pos:1}
        case "$c" in
            [-/:_.!\'\(\)~[:alnum:]]) o="${c}" ;;
            *) printf -v o '%%%02X' "'${c}" ;;
        esac
        encoded+="${o}"
    done
    printf '\e]7;file://%s%s\e\\' "$hostname" "$encoded"
}

add-zsh-hook -Uz chpwd _wezterm_osc7_cwd
_wezterm_osc7_cwd
