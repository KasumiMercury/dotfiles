# Linux で elan の Lean ツールチェーンが壊れたときの直し方

Linux（WSL を含む）では、elan が入れた Lean ツールチェーン（`~/.elan/toolchains/<名前>`）が Nix store のパスを絶対パスで参照する。
参照先の store パスが消えるとツールチェーンが動かなくなるので、ツールチェーンを入れ直して直す。
macOS では起きない。

## 原因

nixpkgs の elan は、Linux ではダウンロードしたツールチェーンの `bin/` に次の変更を加える。

- 各バイナリの ELF interpreter を、Nix の glibc の動的リンカに書き換える。
- `lake` と `leanc` を、Nix の `cc` とシェルを呼ぶラッパーに置き換える。
- `llvm-ar` を、Nix の `ar` へのシンボリックリンクに置き換える。

これらの store パスは elan のビルド時に決まる。
この dotfiles では、`flake.lock` の nixpkgs を更新して `home-manager switch` したときに変わる。
古いパスは、古い home-manager の世代が残っている間は消えない。
古い世代を消して GC したとき（`nh clean` の定期実行、`nix-collect-garbage -d` など）に消え、ツールチェーンが壊れる。

`.bin/home-manager.sh` は、switch の直後に、今の elan の closure にない store パスを参照するツールチェーンを入れ直す。
この文書の手順は、それを経ずに switch した場合や、入れ直しに失敗した場合に使う。

## 症状

`lean` や `lake` を実行すると、ファイルは存在するのに「見つからない」というエラーで止まる。
interpreter の動的リンカやラッパーのシェルが消えているためで、メッセージはシェルによって `required file not found`、`No such file or directory`、`bad interpreter` などになる。

## 直し方

壊れたツールチェーンの名前を `elan toolchain list` で調べ、入れ直す。

```sh
elan toolchain uninstall leanprover/lean4:v4.37.0-rc1
elan toolchain install leanprover/lean4:v4.37.0-rc1
```

`lake build` で作った実行ファイルも古い動的リンカを参照するので、`lake build` し直す。
