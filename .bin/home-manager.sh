#!/usr/bin/env bash
set -ue

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd -P)"
DOT_DIR="$(dirname "$SCRIPT_DIR")"
SRC_DIR="$DOT_DIR/home-manager"
HM_CONFIG_DIR="$HOME/.config/home-manager"
HM_USER="${HM_USER:-mercury}"

echo "=== home-manager config setup ==="
echo "Source: $SRC_DIR"
echo "Dest:   $HM_CONFIG_DIR"

if ! command -v nix >/dev/null 2>&1; then
    echo "Error: nix is not installed."
    echo "Install Nix first (Determinate Systems installer enables flakes by default):"
    echo "  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install"
    exit 1
fi

mkdir -p "$(dirname "$HM_CONFIG_DIR")"

if [ -L "$HM_CONFIG_DIR" ]; then
    current_target="$(readlink "$HM_CONFIG_DIR")"
    if [ "$current_target" = "$SRC_DIR" ]; then
        echo "Already linked correctly."
    else
        echo "Replacing existing symlink (was: $current_target)"
        rm -f "$HM_CONFIG_DIR"
        ln -s "$SRC_DIR" "$HM_CONFIG_DIR"
    fi
elif [ -e "$HM_CONFIG_DIR" ]; then
    BACKUP="${HM_CONFIG_DIR}.dotbackup-$(date +%Y%m%d-%H%M%S)"
    echo "Backing up existing $HM_CONFIG_DIR -> $BACKUP"
    mv "$HM_CONFIG_DIR" "$BACKUP"
    ln -s "$SRC_DIR" "$HM_CONFIG_DIR"
else
    ln -s "$SRC_DIR" "$HM_CONFIG_DIR"
fi

echo "Linked: $HM_CONFIG_DIR -> $SRC_DIR"

# Pure flake evaluation requires flake.nix / flake.lock to be tracked by git.
cd "$DOT_DIR"
untracked=()
for f in home-manager/flake.nix home-manager/flake.lock home-manager/home.nix; do
    if [ ! -f "$f" ]; then
        echo "Warning: $f not found in repository."
        continue
    fi
    if ! git ls-files --error-unmatch "$f" >/dev/null 2>&1 \
       && ! git diff --cached --name-only -- "$f" | grep -qx "$f"; then
        untracked+=("$f")
    fi
done
if [ ${#untracked[@]} -gt 0 ]; then
    echo ""
    echo "Warning: the following files are not tracked by git."
    echo "Pure flake evaluation cannot see them. Run 'git add' before activating:"
    for f in "${untracked[@]}"; do
        echo "  git add $f"
    done
fi

echo ""
read -p "Run 'home-manager switch' now? (y/N): " answer
if [[ "${answer,,}" == "y" ]]; then
    nix run home-manager/master -- switch --flake "${HM_CONFIG_DIR}#${HM_USER}"
else
    echo "Skipped. To apply later, run:"
    echo "  nix run home-manager/master -- switch --flake \"${HM_CONFIG_DIR}#${HM_USER}\""
fi

echo -e "\e[1;36m home-manager setup completed! \e[m"
