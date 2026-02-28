inputs: let
  inherit (builtins) functionArgs length mapAttrs;

  hmSetupModule = specialArgs: {purePkgs, ...}: {
    home-manager.extraSpecialArgs = specialArgs // {inherit purePkgs;};
  };
in rec {
  # This is for packages from flakes that don't offer overlays
  overrideAll = pkgs: pkg: extraArgs: let
    inherit (pkgs.lib) head splitString;

    pkgFile = head (splitString [":"] pkg.meta.position);
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
    patches = [];

    nixpkgs' =
      if length patches == 0
      then nixpkgs
      else
        (import nixpkgs {inherit system;}).applyPatches {
          name = "nixpkgs-patched";
          src = nixpkgs;
          inherit patches;
        };
  in
    import nixpkgs' {
      inherit system;
      overlays = nixpkgs.lib.unique (
        [
          (inputs.self.overlays.nix-version {inherit nix;})

          # Expose this flake's packages to `pkgs`
          inputs.self.overlays.misc-fixes
          inputs.self.overlays.appsPackages
          inputs.self.overlays.selfPackages
          inputs.self.overlays.scopedPackages
        ]
        ++ (cfg.overlays or [])
      );
      config =
        {
          inherit cudaSupport;
          allowUnfree = true;

          # In case I need an insecure package in my devShells
          permittedInsecurePackages = (cfg.config.permittedInsecurePackages or []) ++ [];
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
    system ? "x86_64-linux",
  }:
    inputs.nixpkgs.lib.nixosSystem rec {
      inherit system;
      specialArgs = inputs // {inherit mainUser;};
      modules =
        [
          inputs.home-manager.nixosModules.home-manager

          (allowModularOverrides {inherit system cudaSupport;})
          (hmSetupModule specialArgs)
        ]
        ++ extraModules;
    };

  mkNixDarwin = {
    extraModules ? [],
    mainUser ? "matt",
    system,
  }:
    inputs.nix-darwin.lib.darwinSystem rec {
      inherit system;
      specialArgs = inputs // {inherit mainUser;};
      modules =
        [
          {nixpkgs.hostPlatform = system;}
          inputs.home-manager.darwinModules.home-manager

          (allowModularOverrides {inherit system;})
          (hmSetupModule specialArgs)
        ]
        ++ extraModules;
    };
}
