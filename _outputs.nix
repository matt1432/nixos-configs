{
  inputs = import ./inputs;

  outputs = inputs @ {
    self,
    systems,
    nixpkgs,
    secrets,
    ...
  }: let
    inherit (self.lib) mkNixOS mkNixOnDroid mkPkgs;

    perSystem = attrs:
      nixpkgs.lib.genAttrs (import systems) (system:
        attrs (mkPkgs {inherit system nixpkgs;}));
  in {
    lib = import ./lib {inherit inputs perSystem;};

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
        extraModules = [./configurations/binto];
      };

      bbsteamie = mkNixOS {
        mainUser = "mariah";
        extraModules = [./configurations/bbsteamie];
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

      # Home-assistant
      homie = mkNixOS {
        extraModules = [
          ./configurations/homie
          secrets.nixosModules.homie
        ];
      };

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
