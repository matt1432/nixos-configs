{
  outputs = inputs @ {
    self,
    home-manager,
    nixpkgs,
    ...
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux"];

    perSystem = attrs:
      nixpkgs.lib.genAttrs supportedSystems (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        attrs system pkgs);

    # Default system
    system = "x86_64-linux";
    specialArgs = inputs;
    defaultModules = [
      {home-manager.extraSpecialArgs = inputs;}
      ./common
    ];
  in {
    nixosConfigurations = {
      wim = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules =
          defaultModules
          ++ [./devices/wim];
      };

      binto = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules =
          defaultModules
          ++ [./devices/binto];
      };
    };

    formatter = perSystem (_: pkgs: pkgs.alejandra);
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nur.url = "github:nix-community/NUR";

    nix-gaming.url = "github:fufexan/nix-gaming";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Oksys flakes
    headscale = {
      url = "github:juanfont/headscale";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caddy-plugins = {
      url = "github:matt1432/nixos-caddy-patched";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pihole = {
      url = "github:matt1432/pihole-flake";
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

    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
