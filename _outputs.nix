{
  inputs = let
    inherit (import ./inputs) mkDep mkInput extraInputs;

    mainInputs = {
      systems = mkInput {
        owner = "nix-systems";
        repo = "default-linux";
      };

      nixpkgs = mkInput {
        owner = "NixOS";
        repo = "nixpkgs";
        ref = "nixos-unstable-small";
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
    };
  in
    mainInputs // extraInputs;

  outputs = inputs @ {
    self,
    systems,
    nixpkgs,
    secrets,
    ...
  }: let
    inherit (self.lib) mkVersion mkNixOS mkNixOnDroid mkPkgs;

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

    homeManagerModules = import ./homeManagerModules self;

    nixosModules = import ./modules {inherit self;};

    overlays = import ./overlays self;

    apps =
      perSystem (pkgs:
        import ./apps {inherit pkgs self;});

    appsPackages =
      perSystem (pkgs:
        import ./apps/packages.nix {inherit inputs pkgs;});

    devShells =
      perSystem (pkgs:
        import ./devShells {inherit pkgs self;});

    packages =
      perSystem (pkgs:
        import ./packages {inherit inputs mkVersion pkgs;});

    scopedPackages =
      perSystem (pkgs:
        import ./scopedPackages {inherit inputs mkVersion pkgs;});

    formatter = perSystem (pkgs: pkgs.alejandra);
  };
}
