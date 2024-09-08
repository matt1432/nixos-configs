{
  inputs = let
    inherit (import ./inputs.nix) mkDep mkInput otherInputs;

    mainInputs = {
      systems = mkInput {
        owner = "nix-systems";
        repo = "default-linux";
      };

      nixpkgs = mkInput {
        owner = "NixOS";
        repo = "nixpkgs";
        ref = "nixos-unstable";
      };

      home-manager = mkDep {
        owner = "nix-community";
        repo = "home-manager";
      };

      nix-on-droid = mkDep {
        owner = "nix-community";
        repo = "nix-on-droid";

        inputs.home-manager.follows = "home-manager";
      };

      sops-nix = mkDep {
        owner = "Mic92";
        repo = "sops-nix";
      };

      secrets = mkDep {
        type = "git";
        url = "ssh://git@git.nelim.org/matt1432/nixos-secrets";

        inputs.sops-nix.follows = "sops-nix";
      };

      jovian = mkDep {
        owner = "Jovian-Experiments";
        repo = "Jovian-NixOS";
      };
    };
  in
    mainInputs // otherInputs;

  outputs = inputs @ {
    nixpkgs,
    secrets,
    self,
    systems,
    ...
  }: let
    inherit (import ./lib {inherit inputs;}) mkVersion mkNixOS mkNixOnDroid mkPkgs;

    perSystem = attrs:
      nixpkgs.lib.genAttrs (import systems) (system:
        attrs (mkPkgs {inherit system nixpkgs;}));
  in {
    nixosModules = import ./nixosModules self;

    homeManagerModules = import ./homeManagerModules self;

    nixosConfigurations = {
      # Desktops
      wim = mkNixOS {
        extraModules = [
          ./devices/wim
          secrets.nixosModules.default
        ];
      };
      binto = mkNixOS {
        # FIXME: https://github.com/NixOS/nixpkgs/issues/338315
        # cudaSupport = true;
        extraModules = [./devices/binto];
      };

      bbsteamie = mkNixOS {extraModules = [./devices/bbsteamie];};

      # NAS
      nos = mkNixOS {
        # FIXME: https://github.com/NixOS/nixpkgs/issues/338315
        # cudaSupport = true;
        extraModules = [
          ./devices/nos
          secrets.nixosModules.nos
        ];
      };

      # Build / test server
      servivi = mkNixOS {
        extraModules = [
          ./devices/servivi
          secrets.nixosModules.servivi
        ];
      };

      # Home-assistant
      homie = mkNixOS {
        extraModules = [
          ./devices/homie
          secrets.nixosModules.homie
        ];
      };

      # Cluster
      thingone = mkNixOS {
        extraModules = [
          (import ./devices/cluster "thingone")
          secrets.nixosModules.thingy
        ];
      };
      thingtwo = mkNixOS {
        extraModules = [
          (import ./devices/cluster "thingtwo")
          secrets.nixosModules.thingy
        ];
      };

      live-image = mkNixOS {
        extraModules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          {
            vars = {
              mainUser = "nixos";
              hostName = "nixos";
            };
          }
        ];
      };
    };

    nixOnDroidConfigurations.default =
      mkNixOnDroid [./devices/android];

    legacyPackages =
      perSystem (pkgs:
        import ./legacyPackages {inherit mkVersion pkgs inputs;});

    packages =
      perSystem (pkgs:
        import ./packages {inherit self pkgs mkVersion inputs;});

    overlays = import ./overlays {};

    apps =
      perSystem (pkgs:
        import ./apps {inherit inputs pkgs;});

    devShells = perSystem (pkgs: {
      default = pkgs.mkShell {
        packages = [
          (pkgs.writeShellScriptBin "mkIso" ''
            isoConfig="nixosConfigurations.live-image.config.system.build.isoImage"
            nom build $(realpath /etc/nixos)#$isoConfig
          '')
        ];
      };

      node = pkgs.mkShell {
        packages =
          (builtins.attrValues {
            inherit
              (pkgs)
              nodejs_latest
              typescript
              ;
          })
          ++ [
            (pkgs.writeShellApplication {
              name = "updateNpmDeps";
              runtimeInputs = builtins.attrValues {
                inherit
                  (pkgs)
                  prefetch-npm-deps
                  nodejs_latest
                  ;
              };

              text = ''
                npm i --package-lock-only || true # this command will fail but still updates the main lockfile
                prefetch-npm-deps ./package-lock.json
              '';
            })
          ];
      };

      subtitles-dev = pkgs.mkShell {
        packages = builtins.attrValues {
          inherit
            (pkgs)
            nodejs_latest
            ffmpeg-full
            typescript
            ;

          inherit
            (pkgs.nodePackages)
            ts-node
            ;
        };
      };
    });

    # For nix-fast-build. I use a custom output to alleviate eval time of this flake. ie. when doing nix flake show
    nixFastChecks =
      perSystem (pkgs:
        import ./checks {inherit pkgs self;});

    formatter = perSystem (pkgs: pkgs.alejandra);
  };
}
