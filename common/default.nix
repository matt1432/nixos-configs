{ config
, home-manager
, lib
, nixpkgs
, nixpkgs-wayland
, nh
, nur
, nix-melt
, nurl
, coc-stylelintplus
, pkgs
, ...
}: {
  imports = [
    ./cachix.nix
    home-manager.nixosModules.default
    nh.nixosModules.default
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
    };

    # Minimize dowloads of indirect nixpkgs flakes
    registry.nixpkgs = {
      flake = nixpkgs;
      exact = false;
    };
  };
  nixpkgs.overlays = [
    nixpkgs-wayland.overlay
    coc-stylelintplus.overlay
  ];

  nh = {
    enable = true;
    # weekly cleanup
    clean = {
      enable = true;
      extraArgs = "--keep-since 30d";
    };
  };
  environment.variables.FLAKE = "/home/matt/.nix";

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
