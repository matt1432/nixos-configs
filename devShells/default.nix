{
  pkgs,
  self,
  ...
}: let
  inherit (pkgs.lib) attrValues makeSearchPath;

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

    quickshell = pkgs.mkShell {
      packages = [
        pkgs.quickshell
      ];

      shellHook = ''
        export QML2_IMPORT_PATH="$QML2_IMPORT_PATH:${makeSearchPath "lib/qt-6/qml" [
          pkgs.quickshell
          pkgs.kdePackages.qtdeclarative
        ]}"
      '';
    };

    subtitles-dev = pkgs.callPackage ./subtitle-dev {inherit bumpNpmDeps;};
  }
  // neovimShells
