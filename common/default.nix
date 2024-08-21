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
}: {
  imports = [
    ./vars

    ./modules
    ./packages.nix
    self.nixosModules.borgbackup

    home-manager.nixosModules.home-manager
  ];

  boot.tmp.useTmpfs = true;

  systemd.services.nix-daemon = {
    environment.TMPDIR = "/home/nix-cache";
    preStart = ''
      mkdir -p ${config.systemd.services.nix-daemon.environment.TMPDIR}
    '';
  };

  nix = {
    package = pkgs.nixVersions.nix_2_24;

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

  environment.variables.NPM_CONFIG_GLOBALCONFIG = "/etc/npmrc";
  environment.etc.npmrc.text = ''
    fund = false
    update-notifier = false
  '';

  environment.systemPackages =
    (with pkgs; [
      # Peripherals
      hdparm
      pciutils
      usbutils
      rar
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
