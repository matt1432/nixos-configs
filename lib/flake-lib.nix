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
      overlays =
        (map (i: inputs.${i}.overlays.default) [
          "discord-overlay"
          "grim-hyprland"
          "jovian"
          "nixpkgs-wayland"
        ])
        ++ (builtins.attrValues {
          inherit
            (inputs.self.overlays)
            misc
            xdg-desktop-portal-kde
            ;
        });
    };

  # Function that makes the attrs that make up the specialArgs
  mkArgs = {
    system,
    cudaSupport ? false,
  }:
    inputs
    // {
      pkgs = mkPkgs {
        inherit system cudaSupport;
        inherit (inputs) nixpkgs;
      };
    };

  # Default system
  mkNixOS = {
    extraModules ? [],
    cudaSupport ? false,
  }:
    inputs.nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = mkArgs {inherit system cudaSupport;};
      modules =
        [
          {home-manager.extraSpecialArgs = specialArgs;}
          ../common
        ]
        ++ extraModules;
    };

  mkNixOnDroid = mods:
    inputs.nix-on-droid.lib.nixOnDroidConfiguration rec {
      extraSpecialArgs = mkArgs {system = "aarch64-linux";};
      home-manager-path = inputs.home-manager.outPath;
      pkgs = extraSpecialArgs.pkgs;

      modules = let
        inherit (pkgs.lib) mkOption types;
      in
        [
          ({config, ...}: {
            options = {
              environment.variables.FLAKE = mkOption {
                type = with types; nullOr str;
              };
              environment.systemPackages = mkOption {
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
