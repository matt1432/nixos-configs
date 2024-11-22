{
  config,
  home-manager,
  lib,
  nh,
  nixd,
  pkgs,
  self,
  ...
}: let
  inherit (lib) attrValues filter findFirst isAttrs hasAttr mkIf mkOption types;
in {
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
    package = let
      nixdInput =
        findFirst
        (x: x.pname == "nix") {}
        nixd.packages.${pkgs.system}.nixd.buildInputs;

      throws = x: !(builtins.tryEval x).success;
      hasVersion = x: isAttrs x && hasAttr "version" x;

      nixVersions = filter (x: ! throws x && hasVersion x) (attrValues pkgs.nixVersions);
    in
      findFirst (x: x.version == nixdInput.version) {} nixVersions;

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
  system.fsPackages = builtins.attrValues {
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

  environment.systemPackages = builtins.attrValues {
    # Peripherals
    inherit
      (pkgs)
      hdparm
      pciutils
      usbutils
      rar
      ;
  };

  home-manager.users = let
    inherit (config.vars) mainUser;

    default = {
      imports = [
        # Make the vars be the same on Nix and HM
        {
          options.vars = mkOption {
            type = types.attrs;
            readOnly = true;
            default = config.vars;
          };
        }

        {
          programs.bash = {
            sessionVariables = rec {
              FLAKE = config.environment.variables.FLAKE;
              NH_FLAKE = FLAKE;
            };
            shellAliases.nh = "env -u FLAKE nh";
          };
        }

        ./home
        ./home/trash-d
      ];

      home.stateVersion = config.system.stateVersion;
    };
  in {
    root = default;
    greeter = mkIf (config.services.greetd.enable) default;
    ${mainUser} = default;
  };
}
