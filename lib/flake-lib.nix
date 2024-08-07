inputs: rec {
  # Import pkgs from a nixpkgs instance
  mkPkgs = system: nixpkgs:
    import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays =
        (map (i: inputs.${i}.overlays.default) [
          "discord-overlay"
          "grim-hyprland"
          "jovian"
          "nixpkgs-wayland"
        ])
        ++ [
          inputs.self.overlays.xdg-desktop-portal-kde
        ];
    };

  # Function that makes the attrs that make up the specialArgs
  mkArgs = system:
    inputs
    // {
      pkgs = mkPkgs system inputs.nixpkgs;
    };

  # Default system
  mkNixOS = mods:
    inputs.nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = mkArgs system;
      modules =
        [
          {home-manager.extraSpecialArgs = specialArgs;}
          ../common
        ]
        ++ mods;
    };

  mkNixOnDroid = mods:
    inputs.nix-on-droid.lib.nixOnDroidConfiguration rec {
      extraSpecialArgs = mkArgs "aarch64-linux";
      home-manager-path = inputs.home-manager.outPath;
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
          ../common/nix-on-droid.nix
        ]
        ++ mods;
    };
}
