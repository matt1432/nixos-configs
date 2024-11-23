{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) concatStringsSep getName;

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
  users.users.${baseCfg.user}.extraGroups = [
    locateGroup
  ];

  # TODO: add timer
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

  home-manager.users.${baseCfg.user}.programs.bash.shellAliases = {
    locate = "${pkgs.writeShellScriptBin "lct" ''
      exec ${locate} -d ${database} "$@" 2> >(grep -v "/var/cache/locatedb")
    ''}/bin/lct";

    updatedb = updatedbBin;
  };

  services.locate = {
    enable = true;
    package = pkgs.mlocate;
    localuser = null;
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
}
