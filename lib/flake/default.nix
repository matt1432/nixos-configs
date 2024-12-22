inputs: rec {
  # Import pkgs from a nixpkgs instance
  mkPkgs = {
    system,
    nixpkgs,
    cfg ? {},
    nix ? null,
    cudaSupport ? false,
  }:
    import nixpkgs {
      inherit system;
      overlays =
        [
          (inputs.self.overlays.nix-version {inherit nix;})
          inputs.self.overlays.build-failures
        ]
        ++ (cfg.overlays or []);
      config =
        {
          inherit cudaSupport;
          allowUnfree = true;

          # FIXME: Roslyn-ls uses dotnet6 https://github.com/NixOS/nixpkgs/blob/d3c42f187194c26d9f0309a8ecc469d6c878ce33/pkgs/by-name/ro/roslyn-ls/package.nix#L21
          permittedInsecurePackages =
            [
              "dotnet-core-combined"
              "dotnet-sdk-6.0.428"
              "dotnet-sdk-wrapped-6.0.428"
            ]
            ++ (cfg.config.permittedInsecurePackages or []);
        }
        // (builtins.removeAttrs (
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
    _module.args.pkgs = mkForce pkgs;
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
          {home-manager.extraSpecialArgs = specialArgs;}
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
