{
  description = "A base python project environment configuration using uv";

  inputs = {
    flake-parts.url =
      "github:hercules-ci/flake-parts/864599284fc7c0ba6357ed89ed5e2cd5040f0c04?shallow=1";
    nixpkgs.url =
      "github:NixOS/nixpkgs/269882e9dd6cb934b5fe4ffe9b7eb83f6681f6ea?shallow=1";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems =
        [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.python312
            pkgs.uv
            pkgs.git
            pkgs.gh
            pkgs.wget
            pkgs.imagemagick
            pkgs.jq
            pkgs.openssl
            pkgs.tree
            pkgs.ncdu
            pkgs.xz
            pkgs.readline
            #pkgs.google-cloud-sdk
          ];
          shellHook = ''
            uv --version
            uv sync
          '';
        };
      };
    };
}
