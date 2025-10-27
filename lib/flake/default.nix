inputs: let
  inherit (builtins) functionArgs mapAttrs removeAttrs;
in rec {
  # This is for packages from flakes that don't offer overlays
  overrideAll = pkgs: pkg: extraArgs: let
    pkgFile = pkgs.lib.head (pkgs.lib.splitString [":"] pkg.meta.position);
    args = functionArgs (import pkgFile);
  in
    pkg.override ((mapAttrs (n: v: pkgs.${n} or v) args) // extraArgs);

  # Import pkgs from a nixpkgs instance
  mkPkgs = {
    system,
    nixpkgs,
    cfg ? {},
    nix ? null,
    cudaSupport ? false,
  }: let
    nixpkgs' =
      (import nixpkgs {
        inherit system;
      }).applyPatches
      {
        name = "nixpkgs-patched";
        src = nixpkgs;
        patches = [];
      };
  in
    import nixpkgs' {
      inherit system;
      overlays = nixpkgs.lib.unique ([
          # Needed for nix-version overlay
          inputs.nix-serve-ng.overlays.default

          (inputs.self.overlays.nix-version {inherit nix;})
          inputs.self.overlays.misc-fixes
          inputs.self.overlays.appsPackages
          inputs.self.overlays.selfPackages
          inputs.self.overlays.scopedPackages
          inputs.self.overlays.forced
        ]
        ++ (cfg.overlays or []));
      config =
        {
          inherit cudaSupport;
          allowUnfree = true;

          # In case I need an insecure package in my devShells
          permittedInsecurePackages =
            []
            ++ (cfg.config.permittedInsecurePackages or []);
        }
        // (removeAttrs (
          if cfg.config or null == null
          then {}
          else cfg.config
        ) ["permittedInsecurePackages"]);
    };

  # Enable use of `nixpkgs.overlays` on both NixOS and NixOnDroid
  allowModularOverrides = {
    cudaSupport ? false,
    system,
  }: ({config, ...}: let
    pkgs = mkPkgs {
      cfg = config.nixpkgs;
      nix = config.nix.package;
      inherit system cudaSupport;
      inherit (inputs) nixpkgs;
    };
    inherit (pkgs.lib) mkForce;
  in {
    _module.args = {
      pkgs = mkForce pkgs;

      # Expose a non-overlayed version of nixpkgs to avoid cache misses
      purePkgs = import inputs.nixpkgs {
        inherit system cudaSupport;
        config.allowUnfree = true;
      };
    };
  });

  # Default system
  mkNixOS = {
    extraModules ? [],
    cudaSupport ? false,
    mainUser ? "matt",
  }:
    inputs.nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = inputs // {inherit mainUser;};
      modules =
        [
          (allowModularOverrides {inherit system cudaSupport;})
          inputs.home-manager.nixosModules.home-manager
          ({purePkgs, ...}: {home-manager.extraSpecialArgs = specialArgs // {inherit purePkgs;};})
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
        ]
        ++ extraModules;
    };
}
