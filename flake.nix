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
      wim = mkNixOS [
        ./devices/wim
        secrets.nixosModules.default
      ];
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
        {home-manager.users.nixos.home.stateVersion = "24.05";}
        {vars.mainUser = "nixos";}
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

    arion = {
      type = "github";
      owner = "hercules-ci";
      repo = "arion";

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

      # FIXME: https://github.com/horriblename/hyprgrass/issues/76
      # Commit before PR #73 that breaks swiping
      rev = "0165a9ed8679f3f2c62cc868bdaf620e4520d504";

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

      # FIXME: memory leak on latest neovim git
      rev = "c4caeb6f9e87ea08baece83e6cac351d9bd3bb2f";

      # to make sure plugins and nvim have same binaries
      inputs.nixpkgs.follows = "nixpkgs";
    };

    coc-stylelintplus-flake = {
      type = "github";
      owner = "matt1432";
      repo = "coc-stylelintplus";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    tree-sitter-hyprlang-flake = {
      type = "github";
      owner = "luckasRanarison";
      repo = "tree-sitter-hyprlang";

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
      # Wait for https://gitlab.freedesktop.org/plymouth/plymouth/-/commit/38964e5eafdfc7d8eccf29aa65056f303cad0b25
      # to reach https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/plymouth/default.nix
      owner = "plymouth";
      repo = "plymouth";
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

    # MPV scripts
    modernx-src = {
      type = "github";
      owner = "cyl0";
      repo = "ModernX";
      flake = false;
    };

    persist-properties-src = {
      type = "github";
      owner = "d87";
      repo = "mpv-persist-properties";
      flake = false;
    };

    pointer-event-src = {
      type = "github";
      owner = "christoph-heinrich";
      repo = "mpv-pointer-event";
      flake = false;
    };

    touch-gestures-src = {
      type = "github";
      owner = "christoph-heinrich";
      repo = "mpv-touch-gestures";
      flake = false;
    };

    eisa-scripts-src = {
      type = "github";
      owner = "Eisa01";
      repo = "mpv-scripts";
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
      owner = "matt1432";
      repo = "dracula-plymouth";
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
