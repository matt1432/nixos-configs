{
  pkgs,
  self,
  ...
}: let
  inherit (builtins) attrValues;

  neovimShells = import ./neovim-shells {inherit pkgs self;};

  bumpNpmDeps = pkgs.writeShellApplication {
    name = "bumpNpmDeps";
    runtimeInputs = attrValues {
      inherit
        (pkgs)
        prefetch-npm-deps
        nodejs_latest
        ;
    };
    text = ''
      # this command might fail but still updates the main lockfile
      npm update --package-lock-only || true

      hash="$(prefetch-npm-deps ./package-lock.json)"
      echo "$hash"

      if [[ -f ./default.nix ]]; then
          sed -i "s#npmDepsHash = .*#npmDepsHash = \"$hash\";#" ./default.nix
      fi
    '';
  };
in
  {
    flake = pkgs.callPackage ./flake {};
    default = self.devShells.${pkgs.system}.flake;

    netdaemon = pkgs.callPackage ./netdaemon {};

    node = pkgs.callPackage ./node {inherit bumpNpmDeps;};

    subtitles-dev = pkgs.callPackage ./subtitle-dev {inherit bumpNpmDeps;};
  }
  // neovimShells
