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
    home-manager.nixosModules.home-manager

    ../modules/arion
    ../modules/borgbackup
    ../modules/nvidia.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = import ./overlays inputs;
  };
  boot.tmp.useTmpfs = true;

  nix = {
    # Allow deleting store files with '.' in the name
    package = pkgs.nix.overrideAttrs (o: {
      patches =
        (o.patches or [])
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

  programs.nh = {
    enable = true;
    package = nh.packages.${pkgs.system}.default;

    # weekly cleanup
    clean = {
      enable = true;
      extraArgs = "--keep-since 30d";
    };
  };

  services = {
    fwupd.enable = true;

    xserver.xkb = {
      layout = "ca";
      variant = "multix";
    };
  };

  home-manager = let
    inherit (config.vars) mainUser;
    mainUserConf = config.home-manager.users.${mainUser};

    default = {
      imports = [
        # Make the vars be the same on Nix and HM
        {
          options.vars = lib.mkOption {
            type = lib.types.attrs;
            readOnly = true;
            default = config.vars;
          };
        }

        {
          programs.bash.sessionVariables = {
            FLAKE = config.environment.variables.FLAKE;
          };
        }

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
    users = {
      root =
        default
        // {
          home.stateVersion = mainUserConf.home.stateVersion;
        };
      greeter =
        lib.mkIf (config.services.greetd.enable)
        (default
          // {
            home.stateVersion = mainUserConf.home.stateVersion;
          });

      ${mainUser} = default;
    };
  };
}
