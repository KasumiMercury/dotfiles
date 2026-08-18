{
  description = "Home Manager configuration of mercury";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      mkHome =
        {
          system,
          username,
          homeDirectory,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [
            ./home.nix
            {
              home.username = username;
              home.homeDirectory = homeDirectory;
            }
          ];
        };

      # --impure 実行時は $USER / $HOME を採用する。
      # 純粋評価（nix flake check 等）では getEnv が "" を返すため、
      # mercury / 既定のホームパスへフォールバックする。
      mkEnvHome =
        system:
        let
          envUser = builtins.getEnv "USER";
          envHome = builtins.getEnv "HOME";
          isDarwin = nixpkgs.lib.hasSuffix "darwin" system;
          username = if envUser != "" then envUser else "mercury";
          homeDirectory =
            if envHome != "" then envHome else (if isDarwin then "/Users/" else "/home/") + username;
        in
        mkHome { inherit system username homeDirectory; };
    in
    {
      homeConfigurations = {
        # 既存互換（WSL）: 純粋評価で完結する固定構成。
        "mercury" = mkHome {
          system = "x86_64-linux";
          username = "mercury";
          homeDirectory = "/home/mercury";
        };

        # 任意ユーザー用: --impure で $USER / $HOME を反映する。
        "x86_64-linux" = mkEnvHome "x86_64-linux";
        "aarch64-linux" = mkEnvHome "aarch64-linux";
        "aarch64-darwin" = mkEnvHome "aarch64-darwin";
      };
    };
}
