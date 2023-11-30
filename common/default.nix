{
  config,
  home-manager,
  lib,
  nixpkgs,
  nixpkgs-wayland,
  nix-index-database,
  nh,
  nur,
  nix-melt,
  nurl,
  pkgs,
  ...
}: {
  imports = [
    ./cachix.nix
    ./overlays
    ./device-vars.nix

    home-manager.nixosModules.default
    nh.nixosModules.default

    ./modules/programs.nix
    ./modules/locale.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    # Edit nix.conf
    settings = {
      experimental-features = ["nix-command" "flakes"];
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

  services = {
    fwupd.enable = true;

    xserver = {
      layout = "ca";
      xkbVariant = "multix";
    };

  };

  home-manager.users = let
    default = {
      imports = [
        nur.hmModules.nur
        nix-index-database.hmModules.nix-index
        {
          programs = {
            nix-index-database.comma.enable = true;
            nix-index = {
              enable = true;
              enableBashIntegration = true;
            };
          };
        }

        ./home/bash
        ./home/git.nix
        ./home/neovim
        ./home/tmux.nix

        ./device-vars.nix
        ({osConfig, ...}: {
          services.device-vars = osConfig.services.device-vars;
        })
      ];

      home.packages =
        [
          nix-melt.packages.x86_64-linux.default
          nurl.packages.x86_64-linux.default
        ]
        ++ (with config.nur.repos.rycee; [
          mozilla-addons-to-nix
        ])
        ++ (with pkgs.nodePackages; [
          undollar
        ])
        ++ (with pkgs; [
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
