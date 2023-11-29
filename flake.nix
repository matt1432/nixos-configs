{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nur.url = "github:nix-community/NUR";

    nix-gaming.url = "github:fufexan/nix-gaming";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    headscale = {
      url = "github:juanfont/headscale";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland";
    };

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-flake = {
      url = "github:nix-community/neovim-nightly-overlay";
      # to make sure plugins and nvim have same binaries
      inputs.nixpkgs.follows = "nixpkgs";
    };
    coc-stylelintplus-flake = {
      url = "github:matt1432/coc-stylelintplus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tree-sitter-hypr-flake = {
      url = "github:luckasRanarison/tree-sitter-hypr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh.url = "github:viperML/nh";
    nix-melt.url = "github:nix-community/nix-melt";
    nurl.url = "github:nix-community/nurl";

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    home-manager,
    nix-gaming,
    nixpkgs,
    nur,
    ...
  } @ attrs: let
    defaultModules = [
      nur.nixosModules.nur

      home-manager.nixosModules.home-manager
      {
        home-manager.extraSpecialArgs = attrs;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }

      ./common/default.nix
    ];
  in {
    nixosConfigurations = {
      wim = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules =
          defaultModules
          ++ [
            ./devices/wim
          ];
      };

      binto = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules =
          defaultModules
          ++ [
            ./devices/binto
          ];
      };
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.alejandra;
  };
}
