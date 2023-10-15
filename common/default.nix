{ config, home-manager, lib, nixpkgs, nur, nix-melt, nurl, pkgs, ... }: {

  imports = [
    home-manager.nixosModules.default
    ./modules/programs.nix
    ./modules/locale.nix
    ./overlays/list.nix
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

  home-manager.users = let
    default = {
      imports = [
        nur.hmModules.nur
        ./modules/bash
        ./modules/git
        ./modules/neovim
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
