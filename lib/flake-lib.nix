inputs: rec {
  # Import pkgs from a nixpkgs instance
  mkPkgs = {
    system,
    nixpkgs,
    cudaSupport ? false,
  }:
    import nixpkgs {
      inherit system;
      overlays = [inputs.self.overlays.build-failures];
      config = {
        inherit cudaSupport;
        allowUnfree = true;
      };
    };

  # Enable use of `nixpkgs.overlays` on both NixOS and NixOnDroid
  allowModularOverrides = {
    cudaSupport ? false,
    system,
  }: ({config, ...}: let
    pkgs = mkPkgs {
      inherit system cudaSupport;
      inherit (inputs) nixpkgs;
    };
    inherit (pkgs.lib) composeManyExtensions mkForce;
  in {
    _module.args.pkgs = mkForce (pkgs.extend (composeManyExtensions config.nixpkgs.overlays));
  });

  # Default system
  mkNixOS = {
    extraModules ? [],
    cudaSupport ? false,
  }:
    inputs.nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = inputs;
      modules =
        [
          (allowModularOverrides {inherit system cudaSupport;})
          {home-manager.extraSpecialArgs = specialArgs;}
          ../common
        ]
        ++ extraModules;
    };

  mkNixOnDroid = extraModules: let
    system = "aarch64-linux";
  in
    inputs.nix-on-droid.lib.nixOnDroidConfiguration rec {
      extraSpecialArgs = inputs;
      home-manager-path = inputs.home-manager.outPath;
      pkgs = mkPkgs {
        inherit system;
        inherit (inputs) nixpkgs;
      };

      modules =
        [
          (allowModularOverrides {inherit system;})

          ({
            config,
            lib,
            ...
          }: let
            inherit (lib) mkForce mkOption types;
          in {
            # Adapt NixOnDroid to NixOS options
            options.environment = {
              variables.FLAKE = mkOption {
                type = with types; nullOr str;
              };
              systemPackages = mkOption {
                type = with types; listOf package;
                default = [];
              };
            };

            config.environment.packages = config.environment.systemPackages;

            # This disables the assertion that fails because of nixpkgs.overlays
            config._module.args.isFlake = mkForce false;
          })

          {home-manager = {inherit extraSpecialArgs;};}

          ../common/nix-on-droid.nix
        ]
        ++ extraModules;
    };
}
