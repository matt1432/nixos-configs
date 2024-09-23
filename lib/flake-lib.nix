inputs: rec {
  # Import pkgs from a nixpkgs instance
  mkPkgs = {
    system,
    nixpkgs,
    cudaSupport ? false,
  }:
    import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        inherit cudaSupport;
      };
    };

  allowModularOverrides = {
    cudaSupport,
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

  mkNixOnDroid = mods:
    inputs.nix-on-droid.lib.nixOnDroidConfiguration rec {
      extraSpecialArgs = inputs;
      home-manager-path = inputs.home-manager.outPath;
      inherit (extraSpecialArgs) pkgs;

      modules =
        [
          (allowModularOverrides {system = "aarch64-linux";})

          ({
            config,
            lib,
            ...
          }: let
            inherit (lib) mkOption types;
          in {
            # Adapt NixOnDroid to NixOS options
            options.environment.variables = {
              FLAKE = mkOption {
                type = with types; nullOr str;
              };
              systemPackages = mkOption {
                type = with types; listOf package;
                default = [];
              };
            };

            config.environment.packages = config.environment.systemPackages;
          })

          {home-manager = {inherit extraSpecialArgs;};}

          ../common/nix-on-droid.nix
        ]
        ++ mods;
    };
}
