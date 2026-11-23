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
    version = "1.29.3";

    src = pkgs.fetchFromGitHub {
      owner = "RivoLink";
      repo = "leaf";
      tag = version;
      hash = "sha256-/gV1jzY5fo0DzCCTD8MKb9U0CCUpSC1EsnmTKjJGZAE=";
    };

    cargoHash = "sha256-cxi+nM5dQ5gF5aKmbq+SO+pF7lBmypZaPw+tVmpYYMs=";

    checkFlags = [ "--skip=tests::render_preview::preview_mode_only_before_shows_content" ];

    nativeBuildInputs = [ pkgs.installShellFiles ];

    postInstall = ''
      installShellCompletion completions/leaf.{bash,fish,zsh}
    '';
  };

  eim = pkgs.rustPlatform.buildRustPackage rec {
    pname = "eim";
    version = "0.22.0";

    src = pkgs.fetchFromGitHub {
      owner = "espressif";
      repo = "idf-im-ui";
      tag = "v${version}";
      hash = "sha256-ARE+HamRSSsZ6oEJmr9L8FgxaGJhXl4HCLPvex7ZE8o=";
    };

    sourceRoot = "${src.name}/src-tauri";

    cargoHash = "sha256-Tz5dg1T1pj0xdY4JU0vFcMGyj/Icf2MQLZjFSRuGJvE=";

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
        --set EIM_DO_NOT_TRACK true \
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
