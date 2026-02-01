self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkDefault mkIf mkOption optionalAttrs types;
  inherit (self.inputs) home-manager;

  inherit (pkgs.stdenv.hostPlatform) system;

  cfg = config.roles.base;
in {
  imports = [
    ./locale
    ./locate
    ./substituters
    (import ./common-nix self)
    (import ./packages self)

    self.nixosModules.borgbackup
    self.nixosModules.tmux

    home-manager.nixosModules.home-manager
  ];

  options.roles.base = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };

    user = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    environment.variables.FLAKE = mkDefault "/home/${cfg.user}/.nix";

    programs.tmux.enableCustomConf = true;

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
        fallback = true;

        # remote building
        trusted-users = ["matt" "nixremote"];
      };
    };

    programs.nh = {
      enable = true;
      package = pkgs.nh;

      # weekly cleanup
      clean = {
        enable = true;
        extraArgs = "--keep-since 30d";
      };
    };

    environment.systemPackages = attrValues ({
        # Peripherals
        inherit
          (pkgs)
          hdparm
          pciutils
          usbutils
          ;
      }
      // optionalAttrs (system == "x86_64-linux") {
        inherit
          (pkgs)
          rar
          ;
      });

    services = {
      fwupd.enable = true;

      xserver.xkb = {
        layout = "ca";
        variant = "multix";
      };
    };

    boot.supportedFilesystems = ["ext4" "xfs" "btrfs" "vfat" "ntfs"];
    system.fsPackages = attrValues {
      inherit
        (pkgs)
        btrfs-progs
        nfs-utils
        ntfs3g
        xfsprogs
        ;
    };

    environment.variables.NPM_CONFIG_GLOBALCONFIG = "/etc/npmrc";
    environment.etc.npmrc.text = ''
      fund = false
      update-notifier = false
    '';

    users.mutableUsers = false;

    home-manager.backupFileExtension = "bak";

    home-manager.users = let
      default = {
        imports = [
          {
            programs.bash = {
              sessionVariables = rec {
                FLAKE = config.environment.variables.FLAKE;
                NH_FLAKE = FLAKE;
              };
              shellAliases.nh = "env -u FLAKE nh";
            };
          }
        ];

        home.enableNixpkgsReleaseCheck = false;
        home.stateVersion = config.system.stateVersion;
      };
    in {
      root = default;
      greeter = mkIf (config.services.greetd.enable) default;
      ${cfg.user} = default;
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
