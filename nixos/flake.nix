{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland";
    };
    ags.url = "github:Aylur/ags";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, home-manager, nur, ... }@attrs: {
    nixosConfigurations.wim = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        nur.nixosModules.nur

        ({ ... }: {
          nix = {
            # Edit nix.conf
            settings = {
              experimental-features = [ "nix-command" "flakes" ];
              keep-outputs = true;
              auto-optimise-store = true;
              warn-dirty = false;
            };

            # Minimize dowloads of indirect nixpkgs flakes
            registry = {
              nixpkgs.flake = self.inputs.nixpkgs;
              nixpkgs.exact = false;
            };
          };
        })

        ./configuration.nix

        home-manager.nixosModules.home-manager {
          home-manager.extraSpecialArgs = attrs;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
  };
}
