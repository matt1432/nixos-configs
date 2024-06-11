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

    nur.nixosModules.nur
    home-manager.nixosModules.home-manager

    ../modules/arion
    ../modules/borgbackup
    ../modules/nvidia.nix
  ];

  boot.tmp.useTmpfs = true;

  nix = {
    package = pkgs.nixVersions.git.overrideAttrs (oldAttrs: {
      pname = "nix";
      version = "2.21.3";
      src = pkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nix";
        rev = "60824fa97c588a0faf68ea61260a47e388b0a4e5";
        sha256 = "10z/SoidVl9/lh56cMLj7ntJZHtVrumFvmn1YEqXmaM=";
      };
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
      allow-import-from-derivation = true;

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
      ];

      home.packages =
        [
          nix-melt.packages.${pkgs.system}.default

          (nurl.packages.${pkgs.system}.default.override {
            nix = config.nix.package;
          })
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
