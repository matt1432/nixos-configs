{
  inputs = import ./inputs;

  outputs = inputs @ {
    self,
    systems,
    nixpkgs,
    secrets,
    ...
  }: let
    inherit (self.lib) mkNixOS mkNixDarwin mkPkgs;

    mkPerSystem = supportedSystems: attrs:
      nixpkgs.lib.genAttrs supportedSystems (system:
        attrs (mkPkgs {inherit system nixpkgs;}));

    perSystem = mkPerSystem (import systems);
    perLinuxSystem = mkPerSystem (builtins.filter (nixpkgs.lib.hasSuffix "linux") (import systems));
  in {
    lib = import ./lib {inherit inputs perSystem;};

    darwinConfigurations."MGCOMP0192" = mkNixDarwin {
      mainUser = "mhurtubise";
      system = "x86_64-darwin";
      extraModules = [./configurations/darwin];
    };

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

      android = mkNixOS {
        system = "aarch64-linux";
        extraModules = [./configurations/android];
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

    # For gen-docs
    configurations = let
      inherit (nixpkgs.lib) mapAttrs' nameValuePair;
    in
      self.nixosConfigurations // (mapAttrs' (n: v: nameValuePair "darwin" v) self.darwinConfigurations);

    # For nix-fast-build. I use a custom output to alleviate eval time of this flake. ie. when doing nix flake show
    nixFastChecks = import ./nixFastChecks {
      inherit self;
      perSystem = perLinuxSystem;
    };

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
