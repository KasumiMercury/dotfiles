#!/usr/bin/env bash
# Note: bash 3.2 compatible (macOS ships bash 3.2). Avoid bash 4+ only syntax.
set -ue

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd -P)"
DOT_DIR="$(dirname "$SCRIPT_DIR")"
SRC_DIR="$DOT_DIR/home-manager"
HM_CONFIG_DIR="$HOME/.config/home-manager"

# Guard against 'sudo ./home-manager.sh': with a mismatched $USER/$HOME pair
# the flake (evaluated with --impure) would bake the wrong user into the
# configuration and spray root-owned files into this home directory.
if [ ! -O "$HOME" ]; then
    echo "Error: \$HOME ($HOME) is not owned by the current user."
    echo "Run this script as the target user, without sudo."
    exit 1
fi

# Detect the nix system double for the current machine.
uname_s="$(uname -s)"
uname_m="$(uname -m)"
case "$uname_s" in
    Linux)
        case "$uname_m" in
            x86_64 | amd64) HM_SYSTEM="x86_64-linux" ;;
            aarch64 | arm64) HM_SYSTEM="aarch64-linux" ;;
            *) HM_SYSTEM="" ;;
        esac
        ;;
    Darwin)
        case "$uname_m" in
            arm64 | aarch64) HM_SYSTEM="aarch64-darwin" ;;
            *) HM_SYSTEM="" ;;
        esac
        ;;
    *) HM_SYSTEM="" ;;
esac

if [ -z "$HM_SYSTEM" ]; then
    echo "Error: unsupported platform: $uname_s $uname_m"
    echo "Supported: Linux x86_64 / Linux aarch64 / Darwin arm64"
    exit 1
fi

# HM_USER was replaced by HM_CONFIG: it now names the homeConfigurations
# attribute directly (e.g. HM_CONFIG=mercury for the fixed WSL configuration).
HM_CONFIG="${HM_CONFIG:-$HM_SYSTEM}"

echo "=== home-manager config setup ==="
echo "Source: $SRC_DIR"
echo "Dest:   $HM_CONFIG_DIR"
echo "System: $HM_SYSTEM"
echo "Config: $HM_CONFIG"

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

# Flake evaluation requires flake.nix / flake.lock to be tracked by git.
cd "$DOT_DIR"
# Accumulated as a newline separated string: bash 3.2 cannot expand an empty
# array safely under 'set -u'.
untracked_hint=""
for f in home-manager/flake.nix home-manager/flake.lock home-manager/home.nix; do
    if [ ! -f "$f" ]; then
        echo "Warning: $f not found in repository."
        continue
    fi
    if ! git ls-files --error-unmatch "$f" >/dev/null 2>&1 \
       && ! git diff --cached --name-only -- "$f" | grep -qx "$f"; then
        untracked_hint="${untracked_hint}  git add ${f}
"
    fi
done
if [ -n "$untracked_hint" ]; then
    echo ""
    echo "Warning: the following files are not tracked by git."
    echo "Flake evaluation cannot see them. Run 'git add' before activating:"
    printf '%s' "$untracked_hint"
fi

# --impure lets the flake read $USER / $HOME for the per-system configurations.
# It is harmless for the fixed 'mercury' configuration, so it is always passed.
SWITCH_CMD="nix run home-manager/master -- switch --flake \"${HM_CONFIG_DIR}#${HM_CONFIG}\" --impure"

echo ""
read -p "Run 'home-manager switch' now? (y/N): " answer
answer_lower="$(printf '%s' "${answer:-}" | tr '[:upper:]' '[:lower:]')"
if [ "$answer_lower" = "y" ]; then
    nix run home-manager/master -- switch --flake "${HM_CONFIG_DIR}#${HM_CONFIG}" --impure
else
    echo "Skipped. To apply later, run:"
    echo "  ${SWITCH_CMD}"
fi

printf '\033[1;36m home-manager setup completed! \033[m\n'
