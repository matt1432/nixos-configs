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

      servivi = mkNixOS [
        ./devices/servivi
        secrets.nixosModules.servivi
      ];
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
          (import ./common/overlays/dracula-theme inputs)
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
    # Main inputs
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      type = "git";
      url = "ssh://git@git.nelim.org/matt1432/nixos-secrets";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      type = "github";
      owner = "t184256";
      repo = "nix-on-droid";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    # Overlays
    nixpkgs-wayland = {
      type = "github";
      owner = "nix-community";
      repo = "nixpkgs-wayland";
    };

    nur = {
      type = "github";
      owner = "nix-community";
      repo = "NUR";
    };

    nix-gaming = {
      type = "github";
      owner = "fufexan";
      repo = "nix-gaming";
    };

    # Oksys inputs
    headscale = {
      type = "github";
      owner = "juanfont";
      repo = "headscale";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    caddy-plugins = {
      type = "github";
      owner = "matt1432";
      repo = "nixos-caddy-cloudflare";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Servivi inputs
    nms = {
      type = "github";
      owner = "matt1432";
      repo = "nixos-minecraft-servers";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Desktop inputs
    hyprland = {
      type = "github";
      owner = "hyprwm";
      repo = "Hyprland";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprgrass = {
      type = "github";
      owner = "horriblename";
      repo = "hyprgrass";

      inputs.hyprland.follows = "hyprland";
    };

    ags = {
      type = "github";
      owner = "Aylur";
      repo = "ags";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim inputs
    neovim-flake = {
      type = "github";
      owner = "nix-community";
      repo = "neovim-nightly-overlay";

      # to make sure plugins and nvim have same binaries
      inputs.nixpkgs.follows = "nixpkgs";
    };

    coc-stylelintplus-flake = {
      type = "github";
      owner = "matt1432";
      repo = "coc-stylelintplus";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    tree-sitter-hypr-flake = {
      type = "github";
      owner = "luckasRanarison";
      repo = "tree-sitter-hypr";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix tools
    nurl = {
      type = "github";
      owner = "nix-community";
      repo = "nurl";
    };

    nix-index-db = {
      type = "github";
      owner = "Mic92";
      repo = "nix-index-database";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # FIXME: these prevent from using nixos-install
    nh = {
      type = "github";
      owner = "viperML";
      repo = "nh";
    };

    nix-melt = {
      type = "github";
      owner = "nix-community";
      repo = "nix-melt";
    };

    # -= Non-flake inputs =-

    ## Custom packages
    trash-d-src = {
      type = "github";
      owner = "rushsteve1";
      repo = "trash-d";
      flake = false;
    };

    pam-fprint-grosshack-src = {
      type = "gitlab";
      owner = "mishakmak";
      repo = "pam-fprint-grosshack";
      flake = false;
    };

    pokemon-colorscripts-src = {
      type = "gitlab";
      owner = "phoneybadger";
      repo = "pokemon-colorscripts";
      flake = false;
    };

    ## Overlays
    plymouth-src = {
      type = "gitlab";
      host = "gitlab.freedesktop.org";
      owner = "plymouth";
      repo = "plymouth";

      # https://gitlab.freedesktop.org/plymouth/plymouth/-/issues/236
      # Last commit that works
      rev = "58cc9f84e456ab0510b13d7bdbc13697467ca7be";
      flake = false;
    };

    spotifywm-src = {
      type = "github";
      owner = "dasJ";
      repo = "spotifywm";
      flake = false;
    };

    gpu-screen-recorder-src = {
      type = "git";
      url = "https://repo.dec05eba.com/gpu-screen-recorder";
      flake = false;
    };

    ## Dracula src
    bat-theme-src = {
      type = "github";
      owner = "matt1432";
      repo = "bat";
      flake = false;
    };

    git-theme-src = {
      type = "github";
      owner = "dracula";
      repo = "git";
      flake = false;
    };

    gtk-theme-src = {
      type = "github";
      owner = "dracula";
      repo = "gtk";
      flake = false;
    };

    plymouth-theme-src = {
      type = "github";
      owner = "dracula";
      repo = "plymouth";
      flake = false;
    };

    xresources-theme-src = {
      type = "github";
      owner = "dracula";
      repo = "xresources";
      flake = false;
    };
  };
}
