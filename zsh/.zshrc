# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall

fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
zstyle ':prompt:pure:prompt:success' color green
prompt pure

eval "$(mise activate zsh)"
eval "$(direnv hook zsh)"

eval "$(sheldon source)"

setopt no_beep

# Load PC-specific configuration if it exists.
# Place machine-local settings (paths, secrets, work-only aliases, etc.) in this file.
if [ -f "$HOME/.config/zsh/local.zshrc" ]; then
    source "$HOME/.config/zsh/local.zshrc"
fi
