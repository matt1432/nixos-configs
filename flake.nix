{
  outputs = inputs @ {
    self,
    home-manager,
    nixpkgs,
    nix-on-droid,
    neovim-flake,
    secrets,
    ...
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux"];

    perSystem = attrs:
      nixpkgs.lib.genAttrs supportedSystems (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        attrs system pkgs);

    # Default system
    mkNixOS = mods:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules =
          [
            {home-manager.extraSpecialArgs = inputs;}
            ./common
          ]
          ++ mods;
      };
  in {
    nixosConfigurations = {
      wim = mkNixOS [./devices/wim];
      binto = mkNixOS [./devices/binto];

      servivi = mkNixOS [./devices/servivi];
      oksys = mkNixOS [
        ./devices/oksys
        secrets.nixosModules.oksys
      ];

      live-image = mkNixOS [
        ("${nixpkgs}/nixos/modules/installer/"
          + "cd-dvd/installation-cd-minimal.nix")
        {vars.user = "nixos";}
      ];
    };

    nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
      extraSpecialArgs = inputs;
      home-manager-path = home-manager.outPath;
      pkgs = import nixpkgs {
        system = "aarch64-linux";
        overlays = [
          nix-on-droid.overlays.default
          neovim-flake.overlay
          (import ./common/overlays/dracula-theme)
        ];
      };

      modules = [
        {home-manager.extraSpecialArgs = inputs;}
        ./common/nix-on-droid.nix
        ./devices/android
      ];
    };

    formatter = perSystem (_: pkgs: pkgs.alejandra);

    devShells = perSystem (_: pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          alejandra
          git

          (pkgs.writeShellScriptBin "mkIso" (lib.concatStrings [
            "nix build $(realpath /etc/nixos)#nixosConfigurations."
            "live-image.config.system.build.isoImage"
          ]))
        ];
      };
    });
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    secrets = {
      url = "git+ssh://git@git.nelim.org/matt1432/nixos-secrets";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

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
      url = "github:matt1432/nixos-caddy-cloudflare";
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

    # FIXME: some of these prevent from using nixos-install
    nh.url = "github:viperML/nh";
    nix-melt.url = "github:nix-community/nix-melt";
    nurl.url = "github:nix-community/nurl";

    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
