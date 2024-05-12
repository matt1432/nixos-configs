{
  outputs = inputs @ {
    self,
    nixpkgs,
    nix-on-droid,
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

    # Nix-On-Droid
    inherit (nix-on-droid.lib) nixOnDroidConfiguration;
  in {
    nixosConfigurations = {
      wim = mkNixOS [
        ./devices/wim
        secrets.nixosModules.default
      ];
      binto = mkNixOS [./devices/binto];

      nos = mkNixOS [
        ./devices/nos
        secrets.nixosModules.nos
      ];

      servivi = mkNixOS [
        ./devices/servivi
        secrets.nixosModules.servivi
      ];

      # Cluster
      thingone = mkNixOS [
        (import ./devices/cluster "thingone")
        secrets.nixosModules.thingy
      ];
      thingtwo = mkNixOS [
        (import ./devices/cluster "thingtwo")
        secrets.nixosModules.thingy
      ];

      live-image = mkNixOS [
        ("${nixpkgs}/nixos/modules/installer/"
          + "cd-dvd/installation-cd-minimal.nix")
        {home-manager.users.nixos.home.stateVersion = "24.05";}
        {
          vars = {
            mainUser = "nixos";
            hostName = "nixos";
          };
        }
      ];
    };

    nixOnDroidConfigurations.default = nixOnDroidConfiguration (
      import ./devices/android inputs
    );

    formatter = perSystem (_: pkgs: pkgs.alejandra);

    # CI: https://github.com/Mic92/dotfiles/blob/c2f538934d67417941f83d8bb65b8263c43d32ca/flake.nix#L168
    checks = perSystem (system: pkgs: let
      inherit (pkgs.lib) filterAttrs mapAttrs' nameValuePair;

      nixosMachines = mapAttrs' (
        name: config: nameValuePair "nixos-${name}" config.config.system.build.toplevel
      ) ((filterAttrs (_: config: config.pkgs.system == system)) self.nixosConfigurations);
      devShells = mapAttrs' (n: nameValuePair "devShell-${n}") self.devShells;
    in
      nixosMachines // devShells);

    devShells = perSystem (_: pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          alejandra
          git

          (writeShellScriptBin "mkIso" (lib.concatStrings [
            "nix build $(realpath /etc/nixos)#nixosConfigurations."
            "live-image.config.system.build.isoImage"
          ]))
        ];
      };

      ags = pkgs.mkShell {
        packages = with pkgs; [
          nodejs_latest
        ];
      };

      node-dev = pkgs.mkShell {
        packages = with pkgs;
          [
            nodejs_latest
            ffmpeg
            typescript
          ]
          ++ (with nodePackages; [
            ts-node
          ]);
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

    nix-on-droid = {
      type = "github";
      owner = "nix-community";
      repo = "nix-on-droid";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    sops-nix = {
      type = "github";
      owner = "Mic92";
      repo = "sops-nix";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      type = "git";
      url = "ssh://git@git.nelim.org/matt1432/nixos-secrets";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        sops-nix.follows = "sops-nix";
      };
    };
    #

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
    #

    # Cluster Inputs
    pcsd = {
      type = "github";
      owner = "matt1432";
      repo = "nixos-pcsd";
    };

    headscale = {
      type = "github";
      owner = "juanfont";
      repo = "headscale";

      # FIXME: doesn't work on latest
      rev = "fef8261339899fe526777a7aa42df57ca02021c5";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    caddy-plugins = {
      type = "github";
      owner = "matt1432";
      repo = "nixos-caddy-cloudflare";

      inputs.nixpkgs.follows = "nixpkgs";
    };
    #

    # Servivi inputs
    nms = {
      type = "github";
      owner = "matt1432";
      repo = "nixos-minecraft-servers";

      inputs.nixpkgs.follows = "nixpkgs";
    };
    #

    # Nos inputs
    arion = {
      type = "github";
      owner = "hercules-ci";
      repo = "arion";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    jellyfin-flake = {
      type = "github";
      owner = "matt1432";
      repo = "nixos-jellyfin";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    jellyfin-overlays = {
      type = "github";
      owner = "minijackson";
      repo = "nixpkgs";
      ref = "jellyfin-10.9.0";
    };

    subsync = {
      type = "github";
      owner = "matt1432";
      repo = "subsync";

      # Keep version that uses Sphinxbase
      rev = "ee9e1592ae4ec7c694d8857aa72be079d81ea209";

      inputs.nixpkgs.follows = "nixpkgs";
    };
    #

    # Desktop inputs
    ## Hyprland
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      ref = "nix";
      submodules = true;

      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypr-official-plugins = {
      type = "github";
      owner = "hyprwm";
      repo = "hyprland-plugins";

      inputs.hyprland.follows = "hyprland";
    };

    Hyprspace = {
      type = "github";
      owner = "KZDKM";
      repo = "Hyprspace";

      inputs.hyprland.follows = "hyprland";
    };

    hypridle = {
      type = "github";
      owner = "hyprwm";
      repo = "hypridle";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    grim-hyprland = {
      type = "github";
      owner = "eriedaberrie";
      repo = "grim-hyprland";

      inputs.nixpkgs.follows = "nixpkgs";
    };
    ##

    ## Wayland
    wpaperd = {
      type = "github";
      owner = "danyspin97";
      repo = "wpaperd";

      inputs.nixpkgs.follows = "nixpkgs";
    };
    ##

    ## AGS
    ags = {
      type = "github";
      owner = "Aylur";
      repo = "ags";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    astal = {
      type = "github";
      owner = "Aylur";
      repo = "Astal";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    gtk-session-lock = {
      type = "github";
      owner = "Cu3PO42";
      repo = "gtk-session-lock";

      inputs.nixpkgs.follows = "nixpkgs";
    };
    ##
    #

    # Neovim inputs
    stylelint-lsp = {
      type = "github";
      owner = "matt1432";
      repo = "stylelint-lsp";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixd = {
      type = "github";
      owner = "nix-community";
      repo = "nixd";
    };

    # FIXME: get it from nixpkgs when it gets merged
    basedpyright.url = "github:kiike/nixpkgs/pkgs/basedpyright";

    vimplugin-easytables-src = {
      type = "github";
      owner = "Myzel394";
      repo = "easytables.nvim";
      flake = false;
    };

    vimplugin-ts-error-translator-src = {
      type = "github";
      owner = "dmmulroy";
      repo = "ts-error-translator.nvim";
      flake = false;
    };
    #

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

    nix-eval-jobs = {
      type = "github";
      owner = "nix-community";
      repo = "nix-eval-jobs";
      ref = "release-2.21";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-fast-build = {
      type = "github";
      owner = "Mic92";
      repo = "nix-fast-build";

      inputs.nixpkgs.follows = "nixpkgs";
    };
    #

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

    curseforge-server-downloader-src = {
      type = "github";
      owner = "Malpiszonekx4";
      repo = "curseforge-server-downloader";
      flake = false;
    };
    ##

    ## Overlays
    gpu-screen-recorder-src = {
      type = "git";
      url = "https://repo.dec05eba.com/gpu-screen-recorder";
      flake = false;
    };

    libratbag-src = {
      type = "github";
      owner = "libratbag";
      repo = "libratbag";
      flake = false;
    };

    piper-src = {
      type = "github";
      owner = "libratbag";
      repo = "piper";
      flake = false;
    };
    ##

    ## MPV scripts
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
    ##

    ## Theme sources
    jellyfin-ultrachromic-src = {
      type = "github";
      owner = "CTalvio";
      repo = "Ultrachromic";
      flake = false;
    };

    bat-theme-src = {
      type = "github";
      owner = "matt1432";
      repo = "bat";
      flake = false;
    };

    firefox-gx-src = {
      type = "github";
      owner = "Godiesc";
      repo = "firefox-gx";
      ref = "v.9.0";
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

    nvim-theme-src = {
      type = "github";
      owner = "Mofiqul";
      repo = "dracula.nvim";
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
    ##
    #
  };
}
