{
  config,
  home-manager,
  lib,
  nh,
  nix-melt,
  nur,
  nurl,
  pkgs,
  ...
} @ inputs: {
  imports = [
    ./vars

    ./modules
    ./pkgs

    nur.nixosModules.nur
    nh.nixosModules.default
    home-manager.nixosModules.home-manager

    ../modules/arion
    ../modules/borgbackup
    ../modules/nvidia.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = import ./overlays inputs;
  };
  boot.tmp.cleanOnBoot = true;

  nix = {
    # Allow deleting store files with '.' in the name
    package = pkgs.nix.overrideAttrs (oldAttrs: {
      patches =
        (oldAttrs.patches or [])
        ++ [
          ./overlays/nix/patch
        ];
    });
    # Edit nix.conf
    settings = {
      # Store
      keep-outputs = true;
      keep-derivations = true;
      auto-optimise-store = true;

      # Commands
      experimental-features = ["nix-command" "flakes"];
      http-connections = 0; # unlimited for local cache
      warn-dirty = false;
      show-trace = true;

      # remote building
      trusted-users = ["matt" "nixremote"];
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
  environment.variables.FLAKE = lib.mkDefault "/home/matt/.nix";

  services = {
    fwupd.enable = true;

    xserver.xkb = {
      layout = "ca";
      variant = "multix";
    };
  };

  home-manager.users = let
    inherit (config.vars) mainUser;
    mainUserConf = config.home-manager.users.${mainUser};

    default = {
      imports = [
        # Make the vars be the same on Nix and HM
        ./vars
        {vars = config.vars;}

        nur.hmModules.nur

        ./home
        ./home/trash-d
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
    };
  in {
    root =
      default
      // {
        home.stateVersion = mainUserConf.home.stateVersion;
      };

    # TODO: make user an array?
    ${mainUser} = default;
  };
}
