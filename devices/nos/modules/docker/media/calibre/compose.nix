{
  config,
  pkgs,
  ...
}: let
  inherit (config.khepri) rwDataDir;

  rwPath = rwDataDir + "/media/calibre";
in {
  khepri.compositions."calibre".services = {
    "calibre" = {
      image = import ./images/calibre.nix pkgs;
      restart = "always";

      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/New_York";

        # WebUI vars
        SUBFOLDER = "/calibre/";
        TITLE = "CalibreDB";
        NO_DECOR = "true";
      };

      volumes = ["${rwPath}/data-db:/config"];

      extraHosts = ["lan.nelim.org=10.0.0.130"];
      ports = [
        "8580:8080"
        #"8081:8081"
      ];
      #network_mode = "host";
    };

    "calibre-web" = {
      image = import ./images/calibre-web.nix pkgs;
      restart = "always";

      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/New_York";
        DOCKER_MODS = "linuxserver/mods:universal-calibre";
      };

      volumes = [
        "${rwPath}/data-web:/config"
        "${rwPath}/data-db/Calibre Library:/books"
      ];

      extraHosts = ["lan.nelim.org=10.0.0.130"];
      ports = ["8083:8083"];
    };
  };
}
