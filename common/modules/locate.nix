{
  config,
  pkgs,
  lib,
  ...
}: let
  vars = config.services.device-vars;
  locateGroup = lib.getName config.services.locate.package.name;

  locate = "${config.services.locate.package}/bin/locate";
  updatedb = "${config.services.locate.package}/bin/updatedb";

  database = "/var/lib/locate/locatedb";
  pruneFS = builtins.concatStringsSep " " config.services.locate.pruneFS;
  pruneNames = builtins.concatStringsSep " " config.services.locate.pruneNames;
  prunePaths = builtins.concatStringsSep " " config.services.locate.prunePaths;

  updatedbBin = ''
    ${updatedb} -o ${database} --prunefs "${pruneFS}" \
      --prunepaths "${prunePaths}" --prunenames "${pruneNames}"
  '';
in {
  users.users.${vars.username}.extraGroups = [
    locateGroup
  ];

  systemd.services.locate = {
    wantedBy = ["default.target"];
    serviceConfig = {
      User = vars.username;
      Group = locateGroup;
      StateDirectory = "locate";
      StateDirectoryMode = "0770";
      ExecStart = updatedbBin;
    };
  };

  home-manager.users.${vars.username}.imports = [
    {
      programs.bash.shellAliases = {
        locate = "${pkgs.writeShellScriptBin "lct" ''
          exec ${locate} -d ${database} "$@" 2> >(grep -v "/var/cache/locatedb")
        ''}/bin/lct";

        updatedb = updatedbBin;
      };
    }
  ];

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
