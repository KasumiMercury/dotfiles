{ config, pkgs, ... }:

let
  gwq = pkgs.buildGoModule {
    pname = "gwq";
    version = "0.1.1";

    src = pkgs.fetchFromGitHub {
      owner = "d-kuro";
      repo = "gwq";
      rev = "c4247734968bc3f66addd1e088c19b962c27cfc1";
      hash = "sha256-MfCYFbODWnfPxx+6sLlcMT6tqghgILHB13+ccYqVjBA=";
    };

    vendorHash = "sha256-4K01Xf1EXl/NVX1loQ76l1bW8QglBAQdvlZSo7J4NPI=";

    preCheck = "export HOME=$TMPDIR";
    nativeCheckInputs = [ pkgs.git ];
  };
in

{
  # home.username / home.homeDirectory are injected from flake.nix
  # so that this module can be shared across systems and users.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
  };

  xdg.configFile."sheldon/plugins.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/sheldon/plugins.toml";
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    sheldon

    neovim
    tree-sitter
    sqlite
    ripgrep
    fd
    cargo
    rustc

    deno

    nodejs_24
    pnpm
    biome

    gh
    ghq
    gwq
    fzf
    go-task
    lefthook
    tig
    direnv
    jq
    mise
    zip

    devenv
    devbox

    gnumake
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mercury/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
  };

  programs.git = {
    enable = true;
    includes = [
      { path = "~/.config/git/local.gitconfig"; }
    ];
    settings = {
      user = {
        name = "KasumiMercury";
        email = "88318012+KasumiMercury@users.noreply.github.com";
      };
      init.defaultBranch = "main";
      commit.verbose = true;
      push.autoSetupRemote = true;
      core = {
        autocrlf = "input";
        editor = "nvim";
      };
      credential."https://github.com".helper = [
        ""
        "!${pkgs.gh}/bin/gh auth git-credential"
      ];
      credential."https://gist.github.com".helper = [
        ""
        "!${pkgs.gh}/bin/gh auth git-credential"
      ];
    };
  };

  programs.zoxide = {
    enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
