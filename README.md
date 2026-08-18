# dotfiles

nvim / zsh / git / sheldon などの個人設定と、Nix + home-manager によるパッケージ管理をまとめたリポジトリ。

シンボリックリンクの作成は `.bin/install.sh`、パッケージと一部の設定の管理は home-manager が担当する。

## 対応環境

| 環境 | nix system | 備考 |
| --- | --- | --- |
| WSL2 (Windows) | `x86_64-linux` | 既存環境 |
| Apple Silicon Mac | `aarch64-darwin` | |
| Mac 上の lima VM 内 Linux | `aarch64-linux` | 後述の lima の節を参照 |

Windows ネイティブ（Git Bash / MSYS）でも `.bin/install.sh` は動作するが、home-manager は対象外。

## 前提

### clone 先は `~/dotfiles`

`home-manager/home.nix` が `mkOutOfStoreSymlink` で `${config.home.homeDirectory}/dotfiles/nvim` と `.../dotfiles/sheldon/plugins.toml` を参照している。
このパスは固定なので、リポジトリは必ず `~/dotfiles` に置く。

### Nix

flakes が有効な Nix が必要。
Determinate Systems installer は flakes を既定で有効にする。

[DeterminateSystems/nix-installer: Install Nix and flakes with the fast and reliable Determinate Nix Installer, with over 7 million installs.](https://github.com/DeterminateSystems/nix-installer)

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

macOS では既定で multi-user インストールになり、Apple Silicon にネイティブ対応する。

### pure prompt

`zsh/.zshrc` が `fpath+=($HOME/.zsh/pure)` を前提にしている。
pure は Nix の管理外なので、手動で配置する。

```sh
git clone https://github.com/sindresorhus/pure.git ~/.zsh/pure
```

## セットアップ

```sh
git clone https://github.com/KasumiMercury/dotfiles.git ~/dotfiles
cd ~/dotfiles
./.bin/install.sh
./.bin/home-manager.sh
```

### 1. `.bin/install.sh`

`$OSTYPE` から `linux` / `darwin` / `windows` を判定し、各ディレクトリの `install.sh` を順に実行してシンボリックリンクを張る。
リンク先が実ファイルや実ディレクトリだった場合は `*.dotbackup-<日時>` に退避される。
既存のシンボリックリンクは退避されず、そのまま張り替えられる。

| ディレクトリ | linux | darwin | windows |
| --- | --- | --- | --- |
| `zsh` | `~/.zshrc`、`~/.config/zsh/functions/*.zsh` | 同左 | スキップ |
| `fish` | `~/.config/fish/functions/*.fish` | 同左 | スキップ |
| `nvim` | `~/.config/nvim` | 同左 | `~/AppData/Local/nvim` |
| `git` | nix があればスキップ、なければ `~/.config/git/config` | 同左 | `~/.gitconfig` |
| `sheldon` | nix があればスキップ、なければ `~/.config/sheldon/plugins.toml` | 同左 | スキップ |
| `ideavim` | スキップ | `~/.ideavimrc` | `~/.ideavimrc` |
| `wezterm` | スキップ | スキップ | `~/.wezterm.lua`、`~/keymaps.lua` |

`git` と `sheldon` は `command -v nix` が通る環境ではスキップされる。
これらは home-manager が管理するため。

`zsh` の install.sh は `~/.config/zsh/local.zshrc` が無ければ雛形を作る。
このファイルはリポジトリの管理外で、マシン固有の PATH や alias を書くために `~/.zshrc` から読み込まれる。
git も同様に `~/.config/git/local.gitconfig` を include する。

### 2. `.bin/home-manager.sh`

`~/.config/home-manager` を `~/dotfiles/home-manager` へのシンボリックリンクにし、`uname -s` / `uname -m` から system を判定して `home-manager switch` を実行する。

実際に走るコマンドは次の形。

```sh
nix run home-manager/master -- switch --flake "$HOME/.config/home-manager#<config>" --impure
```

`nix` が PATH に無い場合はインストール手順を表示して終了する。

`sudo` を付けて実行しない。
`$HOME` の所有者が実行ユーザーと異なるとスクリプトが実行を拒否する。
`--impure` 評価では `$USER` と `$HOME` がそのまま構成に焼き込まれるため、root で走らせるとホームディレクトリに root 所有のファイルが撒かれる。

## home-manager の構成

`home-manager/flake.nix` は 4 つの `homeConfigurations` を公開する。

| 属性 | system | ユーザー名 / ホーム | 用途 |
| --- | --- | --- | --- |
| `mercury` | `x86_64-linux` | `mercury` / `/home/mercury` 固定 | 既存 WSL 互換。純粋評価で完結する |
| `x86_64-linux` | `x86_64-linux` | `$USER` / `$HOME`（`--impure` 必須） | 任意ユーザー |
| `aarch64-linux` | `aarch64-linux` | 同上 | lima ゲストなど |
| `aarch64-darwin` | `aarch64-darwin` | 同上 | Apple Silicon Mac |

system 名の属性は `builtins.getEnv` で `$USER` と `$HOME` を読むため `--impure` が要る。
`--impure` を付けずに評価すると `getEnv` が空文字を返し、`mercury` と既定のホームパスにフォールバックする。

`.bin/home-manager.sh` は判定した system と同名の属性を選ぶ。
属性を変えたいときは `HM_CONFIG` で上書きする（旧 `HM_USER` は廃止され、指定しても無視される）。

```sh
HM_CONFIG=mercury ./.bin/home-manager.sh
```

スクリプトを介さず実行する場合は次のようにする。

```sh
nix run home-manager/master -- switch --flake ~/.config/home-manager#aarch64-darwin --impure
```

home-manager が管理するもの:

- `home.packages`（neovim、sheldon、gh、ghq、gwq、fzf、mise、direnv、node、go-task ほか）
- `programs.git`（`~/.config/git/config` を生成し、`~/.config/git/local.gitconfig` を include）
- `programs.zoxide`
- `~/.config/nvim` と `~/.config/sheldon/plugins.toml`（`mkOutOfStoreSymlink` でリポジトリを直接指す）

## 注意点

### flake が読むのは git 管理下のファイルだけ

`nix flake` は git の作業ツリーのうち追跡済みのファイルしか見ない。
`home-manager/flake.nix` などを新規に追加した直後は `git add` してから switch する。
`.bin/home-manager.sh` は未追跡ファイルを検出すると警告を出す。

### `~/.config/nvim` の二重管理

`nvim/install.sh` は nix の有無に関わらず `~/.config/nvim` にリンクを張り、同じパスを home-manager も管理する。
ただしリンク先が同じ `~/dotfiles/nvim` に解決されるため、install.sh を先に実行していても home-manager は同一ターゲットとみなして警告を出すだけで完走する。
上記の順序で実行するかぎり対処は要らない。

`~/.config/nvim` が home-manager 管理外の実ディレクトリとして残っている場合は衝突する。
`.bin/install.sh` を先に走らせれば `*.dotbackup-<日時>` に退避されるが、直接 switch するなら `-b backup` を付ける。

```sh
nix run home-manager/master -- switch --flake ~/.config/home-manager#aarch64-darwin --impure -b backup
```

リポジトリを `~/dotfiles` 以外に clone した場合はリンク先が食い違い、`-b backup` でも回避できない。
clone 先を `~/dotfiles` に揃える。

### wezterm

現在の `wezterm/.wezterm.lua` は `pwsh.exe` を起動する Windows 前提の内容のため、macOS と Linux ではインストールされない。

