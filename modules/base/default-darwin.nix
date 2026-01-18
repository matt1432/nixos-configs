self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkDefault mkIf mkOption types;

  cfg = config.roles.base;
in {
  imports = [
    ./substituters
    (import ./common-nix self)
    (import ./packages self)

    self.nixosModules.tmux
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
    environment.variables.FLAKE = mkDefault "/Users/${cfg.user}/.nix";

    programs.tmux.enableCustomConf = true;

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
      };
    };

    environment.systemPackages = attrValues {
      nh = pkgs.nh.overrideAttrs {
        doCheck = false;
      };

      # Peripherals
      inherit
        (pkgs)
        pciutils
        usbutils
        rar
        ;
    };

    environment.variables.NPM_CONFIG_GLOBALCONFIG = "/etc/npmrc";
    environment.etc.npmrc.text = ''
      fund = false
      update-notifier = false
    '';

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
      };
    in {
      ${cfg.user} = default;
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
