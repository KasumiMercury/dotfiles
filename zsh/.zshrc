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

export PATH=$PATH:~/.local/bin/
export PATH=$PATH:~/.nix-profile/bin/

eval "$(mise activate zsh)"
eval "$(direnv hook zsh)"

eval "$(sheldon source)"

eval "$(zoxide init zsh)"

setopt no_beep

# Load custom shell functions.
if [ -d "$HOME/.config/zsh/functions" ]; then
    for func_file in "$HOME"/.config/zsh/functions/*.zsh(N); do
        source "$func_file"
    done
fi

# Load PC-specific configuration if it exists.
# Place machine-local settings (paths, secrets, work-only aliases, etc.) in this file.
if [ -f "$HOME/.config/zsh/local.zshrc" ]; then
    source "$HOME/.config/zsh/local.zshrc"
fi

# Nix
if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
  . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
fi

