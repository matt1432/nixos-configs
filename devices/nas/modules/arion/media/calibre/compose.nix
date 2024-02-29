{config, ...}: let
  inherit (config.arion) rwDataDir;

  rwPath = rwDataDir + "/media/calibre";
in {
  arion.projects."calibre" = {
    "calibre" = {
      image = ./images/calibre.nix;
      restart = "always";

      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/New_York";
      };

      volumes = ["${rwPath}/data-db:/config"];

      ports = [
        "8580:8080"
        #"8081:8081"
      ];
      #network_mode = "host";
    };

    "calibre-web" = {
      image = ./images/calibre-web.nix;
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

      ports = ["8083:8083"];
    };
  };
}
