{
  config,
  home-manager,
  lib,
  nh,
  nix-melt,
  nurl,
  pkgs,
  self,
  ...
} @ inputs: {
  imports = [
    ./vars

    ./modules

    home-manager.nixosModules.home-manager

    ../modules/borgbackup
  ];

  boot.tmp.useTmpfs = true;

  systemd.services.nix-daemon = {
    environment.TMPDIR = "/home/nix-cache";
    preStart = ''
      mkdir -p ${config.systemd.services.nix-daemon.environment.TMPDIR}
    '';
  };

  nix = {
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

  boot.supportedFilesystems = ["ext4" "xfs" "btrfs" "vfat" "ntfs"];
  system.fsPackages = with pkgs; [
    btrfs-progs
    nfs-utils
    ntfs3g
    xfsprogs
  ];

  environment.systemPackages =
    (with pkgs; [
      # File management
      imagemagick
      unzip
      zip
      unzip
      p7zip
      rar
      unrar

      # Peripherals
      hdparm
      pciutils
      usbutils
    ])
    ++ [
      nix-melt.packages.${pkgs.system}.default

      (nurl.packages.${pkgs.system}.default.override {
        nix = config.nix.package;
      })
    ];

  home-manager = let
    inherit (lib) mapAttrs' nameValuePair;

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

        ./home
        ./home/trash-d
      ];

      # Cache devShells
      home.file = mapAttrs' (n: v:
        nameValuePair ".cache/devShells/${n}" {
          source = v;
        })
      self.devShells.${pkgs.system};
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
