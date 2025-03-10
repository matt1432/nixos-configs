{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) concatStringsSep getName mkIf;

  baseCfg = config.roles.base;
  cfg = config.services.locate;

  locateGroup = getName cfg.package.name;

  locate = "${cfg.package}/bin/locate";
  updatedb = "${cfg.package}/bin/updatedb";

  database = "/var/lib/locate/locatedb";
  pruneFS = concatStringsSep " " cfg.pruneFS;
  pruneNames = concatStringsSep " " cfg.pruneNames;
  prunePaths = concatStringsSep " " cfg.prunePaths;

  updatedbBin = ''
    ${updatedb} -o ${database} --prunefs "${pruneFS}" \
      --prunepaths "${prunePaths}" --prunenames "${pruneNames}"
  '';
in {
  config = mkIf baseCfg.enable {
    users.users.${baseCfg.user}.extraGroups = [
      locateGroup
    ];

    systemd.services.locate = {
      wantedBy = ["default.target"];
      serviceConfig = {
        User = baseCfg.user;
        Group = locateGroup;
        StateDirectory = "locate";
        StateDirectoryMode = "0770";
        ExecStart = updatedbBin;
      };
    };

    systemd.timers.locate = {
      wantedBy = ["timers.target"];
      timerConfig = {
        Unit = "locate.service";
        OnCalendar = "*-*-* *:0/10:50"; # Every 10 minutes
      };
    };

    home-manager.users.${baseCfg.user}.programs.bash.shellAliases = {
      locate = "${pkgs.writeShellScriptBin "lct" ''
        exec ${locate} -d ${database} "$@" 2> >(grep -v "/var/cache/locatedb")
      ''}/bin/lct";

      updatedb = updatedbBin;
    };

    services.locate = {
      enable = true;
      package = pkgs.mlocate;
      interval = "never";

      prunePaths = [
        "/var/lib/flatpak"

        # Defaults
        "/tmp"
        "/var/tmp"
        "/var/cache"
        "/var/lock"
        "/var/run"
        "/var/spool"
        "/nix/var/log/nix"
      ];

      pruneNames = [
        "node_modules"

        # Defaults
        ".bzr"
        ".cache"
        ".git"
        ".hg"
        ".svn"
      ];
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
