# eim の Python venv が壊れたときの直し方

eim が作る ESP-IDF の Python venv（`~/.espressif/tools/python/<版>/venv`）は、Nix store の Python を絶対パスで参照する。
参照先の store パスが消えると venv が使えなくなるので、`eim fix` で直す。

## 原因

venv の `bin/python3` と `pyvenv.cfg` は、eim の wrapper が PATH の先頭に足す `python3-3.14.x-env` の store パスを指す。
このパスは、Python のパッチ版、pip、Python の依存（openssl、zlib、stdenv など）が更新されると変わる。
この dotfiles では、`flake.lock` の nixpkgs を更新して `home-manager switch` したときに変わる。
古いパスは、古い home-manager の世代が残っている間は消えない。
古い世代を消して GC したとき（`nix-collect-garbage -d` など）に消え、venv が壊れる。

## 症状

ESP-IDF の環境を有効にして `idf.py` を実行すると、次のエラーで止まる。

```
idf.py: no such file or directory: /Users/<ユーザー>/.espressif/tools/python/v6.1/venv/bin/python
```

## 直し方

```sh
eim fix -p ~/.espressif/v6.1/esp-idf
```

`-p` には ESP-IDF 本体のパスを渡す。
既定のインストール先では `~/.espressif/<版>/esp-idf` になる。
venv は今の wrapper の Python に張り直され、Python の依存も入れ直される。
ネットワークが要り、1〜2 分かかる。

## 予防

`.bin/home-manager.sh` で switch すると、venv の参照先が新しい eim の Python と違うときに `eim fix` が自動で実行される。
ほかの方法で switch したときは、GC（`nh clean` を含む）の前に `eim fix` を一度実行しておく。
