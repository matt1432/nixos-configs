{
  outputs = inputs @ {
    self,
    home-manager,
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
        {vars.mainUser = "nixos";}
      ];
    };

    nixOnDroidConfigurations.default = nixOnDroidConfiguration (
      import ./devices/android inputs
    );

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

      ags = pkgs.mkShell {
        packages = with pkgs; [
          nodejs_18
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
      # FIXME: wait for https://github.com/nix-community/home-manager/pull/5038
      owner = "matt1432";
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
      # FIXME: https://github.com/fufexan/nix-gaming/issues/161
      # owner = "fufexan";
      owner = "NotAShelf";
      repo = "nix-gaming";
    };

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

      # FIXME: wait for nixpkgs to reach this : https://github.com/juanfont/headscale/commit/94b30abf56ae09d82a1541bbc3d19557914f9b27
      rev = "00e7550e760b2d3d759471ff55d2b6e2dc81ad2b";

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

    # Desktop inputs
    nixpkgs-nvidia = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";

      # This was the last commit where my nvidia drivers
      # were working correctly while gaming
      rev = "1536926ef5621b09bba54035ae2bb6d806d72ac8";
    };

    hyprland = {
      type = "github";
      owner = "hyprwm";
      repo = "Hyprland";

      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      type = "github";
      owner = "hyprwm";
      repo = "hypridle";

      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      type = "github";
      owner = "hyprwm";
      repo = "hyprlock";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # FIXME: https://github.com/horriblename/hyprgrass/issues/76
    hyprgrass = {
      type = "github";
      owner = "horriblename";
      repo = "hyprgrass";

      inputs.hyprland.follows = "hyprland";
    };

    hycov = {
      type = "github";
      owner = "Ayuei";
      repo = "hycov";

      inputs.hyprland.follows = "hyprland";
    };

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

    coc-stylelintplus = {
      type = "github";
      owner = "matt1432";
      repo = "coc-stylelintplus";

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

    curseforge-server-downloader-src = {
      type = "github";
      owner = "Malpiszonekx4";
      repo = "curseforge-server-downloader";
      flake = false;
    };

    ## Overlays
    spotifywm-src = {
      # FIXME: remove this input once this gets merged: https://github.com/NixOS/nixpkgs/pull/261501
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

    ## Dracula and theme src
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
  };
}
