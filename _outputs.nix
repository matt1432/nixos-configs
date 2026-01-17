{
  inputs = import ./inputs;

  outputs = inputs @ {
    self,
    systems,
    nixpkgs,
    secrets,
    ...
  }: let
    inherit (self.lib) mkNixOS mkNixDarwin mkNixOnDroid mkPkgs;

    perSystem = attrs:
      nixpkgs.lib.genAttrs (import systems) (system:
        attrs (mkPkgs {inherit system nixpkgs;}));
  in {
    lib = import ./lib {inherit inputs perSystem;};

    darwinConfigurations."MGCOMP0192" = mkNixDarwin {
      mainUser = "mhurtubise";
      system = "x86_64-darwin";
      extraModules = [
        ./configurations/darwin

        ({pkgs, ...}: {
          nix = {
            package = pkgs.lixPackageSets.stable.lix;
            settings = {
              experimental-features = "nix-command flakes";
              substituters = ["https://cache.nelim.org?priority=200" "https://cache.nixos.org/"];
              trusted-public-keys = ["cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "cache.nelim.org:JmFqkUdH11EA9EZOFAGVHuRYp7EbsdJDHvTQzG2pPyY="];
              warn-dirty = false;
            };
          };
        })
      ];
    };

    nixOnDroidConfigurations.default =
      mkNixOnDroid [./configurations/android];

    nixosConfigurations = {
      # Desktops
      wim = mkNixOS {
        extraModules = [
          ./configurations/wim
          secrets.nixosModules.default
        ];
      };
      binto = mkNixOS {
        cudaSupport = true;
        extraModules = [
          ./configurations/binto
          secrets.nixosModules.default
        ];
      };

      # NAS
      nos = mkNixOS {
        cudaSupport = true;
        extraModules = [
          ./configurations/nos
          secrets.nixosModules.nos
        ];
      };

      # Build / test server
      servivi = mkNixOS {
        extraModules = [
          ./configurations/servivi
          secrets.nixosModules.servivi
        ];
      };

      # TODO: re-enable this when homie is back up
      # Home-assistant
      /*
        homie = mkNixOS {
        extraModules = [
          ./configurations/homie
          secrets.nixosModules.homie
        ];
      };
      */

      # Cluster
      thingone = mkNixOS {
        extraModules = [
          (import ./configurations/cluster "thingone")
          secrets.nixosModules.thingy
        ];
      };
      thingtwo = mkNixOS {
        extraModules = [
          (import ./configurations/cluster "thingtwo")
          secrets.nixosModules.thingy
        ];
      };

      live-image = mkNixOS {
        mainUser = "nixos";
        extraModules = [./configurations/live-image];
      };
    };

    # For nix-fast-build. I use a custom output to alleviate eval time of this flake. ie. when doing nix flake show
    nixFastChecks = import ./nixFastChecks {inherit perSystem self;};

    homeManagerModules = import ./homeManagerModules {inherit self;};

    nixosModules = import ./modules {inherit self;};

    overlays = import ./overlays {inherit self;};

    apps =
      perSystem (pkgs:
        import ./apps {inherit pkgs self;});

    appsPackages = perSystem (pkgs: pkgs.appsPackages);

    devShells =
      perSystem (pkgs:
        import ./devShells {inherit pkgs self;});

    packages = perSystem (pkgs: pkgs.selfPackages);

    scopedPackages = perSystem (pkgs: pkgs.scopedPackages);

    formatter = perSystem (pkgs: pkgs.alejandra);
  };
}
