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
}
