{
  grim-hyprland,
  home-manager,
  nix-on-droid,
  nixpkgs,
  nixpkgs-wayland,
  ...
} @ inputs: rec {
  # Import pkgs from a nixpkgs
  mkPkgs = system: input:
    import input {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        grim-hyprland.overlays.default
        nixpkgs-wayland.overlays.default
      ];
    };

  # Function that makes the attrs that make up the specialArgs
  mkArgs = system:
    inputs
    // {
      pkgs = mkPkgs system nixpkgs;
    };

  # Default system
  mkNixOS = mods:
    nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = mkArgs system;
      modules =
        [
          {home-manager.extraSpecialArgs = specialArgs;}
          ./common
        ]
        ++ mods;
    };

  mkNixOnDroid = mods:
    nix-on-droid.lib.nixOnDroidConfiguration rec {
      extraSpecialArgs = mkArgs "aarch64-linux";
      home-manager-path = home-manager.outPath;
      pkgs = extraSpecialArgs.pkgs;

      modules =
        [
          {
            options = with pkgs.lib; {
              environment.variables.FLAKE = mkOption {
                type = with types; nullOr str;
              };
            };
          }
          {home-manager = {inherit extraSpecialArgs;};}
          ./common/nix-on-droid.nix
        ]
        ++ mods;
    };
}
