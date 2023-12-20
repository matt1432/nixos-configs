{
  config,
  lib,
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

      # remote building
      trusted-users = ["matt"];
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

  home-manager.users = let
    default = {
      imports = [
        # Make the vars be the same on Nix and HM
        ./vars.nix
        {vars = config.vars;}

        nur.hmModules.nur

        ./home
        ./pkgs
      ];

      home.packages =
        [
          nix-melt.packages.${pkgs.system}.default
          nurl.packages.${pkgs.system}.default
        ]
        ++ (with config.nur.repos.rycee; [
          mozilla-addons-to-nix
        ]);
      home.stateVersion = lib.mkDefault "23.05";
    };
  in {
    root = default;
    # TODO: make user an array?
    ${config.vars.user} = default;
  };
}
