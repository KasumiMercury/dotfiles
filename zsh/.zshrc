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
eval "$(devenv hook zsh)"

eval "$(sheldon source)"

eval "$(zoxide init zsh)"

setopt no_beep

# Load custom shell functions.
if [ -d "$HOME/.config/zsh/functions" ]; then
    for func_file in "$HOME"/.config/zsh/functions/*.zsh(N); do
        source "$func_file"
    done
fi

# Load every *.zshrc under ~/.config/zsh (sorted by name).
# - local.zshrc: machine-local settings (paths, secrets, work-only aliases, etc.), not tracked by dotfiles.
# - wsl.zshrc:   linked by zsh/install.sh only on WSL.
for rc_file in "$HOME"/.config/zsh/*.zshrc(N); do
    source "$rc_file"
done

# Nix
if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
  . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
fi

# home-manager session variables (home.sessionVariables)
if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi

