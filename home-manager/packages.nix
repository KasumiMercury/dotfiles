pkgs: {
  gwq = pkgs.buildGoModule rec {
    pname = "gwq";
    version = "0.1.2";

    src = pkgs.fetchFromGitHub {
      owner = "d-kuro";
      repo = "gwq";
      tag = "v${version}";
      hash = "sha256-X1qkQUEhBqhMvdStN2YMj7nmqHWpO//y6afrBdAmVUI=";
    };

    vendorHash = "sha256-4K01Xf1EXl/NVX1loQ76l1bW8QglBAQdvlZSo7J4NPI=";

    preCheck = "export HOME=$TMPDIR";
    nativeCheckInputs = [ pkgs.git ];
  };

  leaf = pkgs.rustPlatform.buildRustPackage rec {
    pname = "leaf";
    version = "1.29.2";

    src = pkgs.fetchFromGitHub {
      owner = "RivoLink";
      repo = "leaf";
      tag = version;
      hash = "sha256-Qj5QfuoXmh+YH3+MrPKmTKjDPAYIOrewJf3LastPJQo=";
    };

    cargoHash = "sha256-eAPW1VhBEyrQBKeFniKD1RxCdy6p6teAVwnNRBWJ+BA=";

    checkFlags = [ "--skip=tests::render_preview::preview_mode_only_before_shows_content" ];

    nativeBuildInputs = [ pkgs.installShellFiles ];

    postInstall = ''
      installShellCompletion completions/leaf.{bash,fish,zsh}
    '';
  };

  eim = pkgs.rustPlatform.buildRustPackage rec {
    pname = "eim";
    version = "0.21.0";

    src = pkgs.fetchFromGitHub {
      owner = "espressif";
      repo = "idf-im-ui";
      tag = "v${version}";
      hash = "sha256-yrcyl8/dFTeRkkCvXoycPTws6eQOE0JZU6Z5ZHvzgYg=";
    };

    sourceRoot = "${src.name}/src-tauri";

    cargoHash = "sha256-tUQnTKskZ5gsjKhUH51u3oBUPtSbp/dxnm8zVZQkODg=";

    buildNoDefaultFeatures = true;
    buildFeatures = [ "cli" ];

    nativeBuildInputs = with pkgs; [
      pkg-config
      perl
      cmake
      makeWrapper
      installShellFiles
    ];
    buildInputs = [
      pkgs.openssl
      pkgs.zstd
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ pkgs.libiconv ];

    dontUseCmakeConfigure = true;

    preBuild = ''
      unset AWS_LC_SYS_USE_SYSTEM
      unset LIBGIT2_NO_VENDOR
    '';

    doCheck = false;

    postInstall = ''
      installManPage ../man/eim.1
      installShellCompletion --cmd eim \
        --bash <($out/bin/eim completions bash) \
        --zsh <($out/bin/eim completions zsh) \
        --fish <($out/bin/eim completions fish)
      wrapProgram $out/bin/eim \
        --prefix PATH : ${pkgs.lib.makeBinPath [ (pkgs.python314.withPackages (ps: [ ps.pip ])) ]} \
        --suffix PATH : ${
          pkgs.lib.makeBinPath (
            with pkgs;
            [
              git
              wget
              flex
              bison
              gperf
              cmake
              ninja
              dfu-util
              gnused
              gnugrep
              coreutils
              findutils
            ]
          )
        }
    '';
  };
}
