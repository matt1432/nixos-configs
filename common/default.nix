{
  config,
  lib,
  nixpkgs,
  home-manager,
  nh,
  nix-melt,
  nur,
  nurl,
  pkgs,
  ...
}: {
  imports = [
    ./vars.nix

    ./modules
    ./overlays
    ./pkgs

    nur.nixosModules.nur
    nh.nixosModules.default
    home-manager.nixosModules.home-manager
  ];

  nixpkgs.config.allowUnfree = true;
  boot.tmp.cleanOnBoot = true;

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

  # Global hm settings
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users = let
    default = {
      imports = [
        # Make the vars be the same on Nix and HM
        ./vars.nix
        ({osConfig, ...}: {vars = osConfig.vars;})

        nur.hmModules.nur

        ./home
        ./pkgs
      ];

      home.packages =
        [
          nix-melt.packages.${pkgs.system}.default
          nurl.packages.${pkgs.system}.default
        ]
        ++ (with config.customPkgs; [
          pokemon-colorscripts
          repl
        ])
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
          zip
        ]);
      home.stateVersion = lib.mkDefault "23.05";
    };
  in {
    root = default;
    # TODO: make user an array?
    ${config.vars.user} = default;
  };
}
