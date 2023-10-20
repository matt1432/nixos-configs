{ config
, home-manager
, lib
, nixpkgs
, nixpkgs-wayland
, nur
, nix-melt
, nurl
, pkgs
, ...
}: {
  imports = [
    home-manager.nixosModules.default
    ./modules/programs.nix
    ./modules/locale.nix
    ./overlays

    ./hostvars.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    # Edit nix.conf
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      keep-outputs = true;
      keep-derivations = true;
      auto-optimise-store = true;
      warn-dirty = false;

      # Cachix
      substituters = [
        "https://hyprland.cachix.org"
        "https://nix-gaming.cachix.org"
        # Nixpkgs-Wayland
        "https://cache.nixos.org"
        "https://nixpkgs-wayland.cachix.org"
        #
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        # Nixpkgs-Wayland
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        #
      ];
    };

    # Minimize dowloads of indirect nixpkgs flakes
    registry.nixpkgs = {
      flake = nixpkgs;
      exact = false;
    };
  };
  nixpkgs.overlays = [ nixpkgs-wayland.overlay ];

  services.xserver = {
    layout = "ca";
    xkbVariant = "multix";
  };

  home-manager.users = let
    default = {
      imports = [
        nur.hmModules.nur
        ./modules/bash
        ./modules/git.nix
        ./modules/neovim
        ./modules/tmux.nix

        ./hostvars.nix
        ({ osConfig, ... }: {
          services.hostvars = osConfig.services.hostvars;
        })
      ];

      home.packages = [
        nix-melt.packages.x86_64-linux.default
        nurl.packages.x86_64-linux.default
      ] ++

      (with config.nur.repos.rycee; [
        mozilla-addons-to-nix
      ]) ++

      (with pkgs.nodePackages; [
        undollar
      ]) ++

      (with pkgs; [
        dracula-theme
        neofetch
        progress
        wget
        tree
        mosh
        rsync
        killall
        imagemagick
        usbutils
      ]);

      home.stateVersion = lib.mkDefault "23.05";
    };
  in {
    root = default;
    matt = default;
  };
}
