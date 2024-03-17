{config, ...}: let
  inherit (config.arion) rwDataDir;

  rwPath = rwDataDir + "/music/jbots";
in {
  arion.projects."jbots" = {
    "musicbot_be" = {
      container_name = "benis";
      image = ./images/jmusicbot.nix;
      restart = "always";

      volumes = [
        "${rwPath}/be/config.txt:/jmb/config/config.txt:ro"
        "${rwPath}/be/playlists:/jmb/config/playlists:rw"
      ];
    };

    "musicbot_br" = {
      container_name = "bruh";
      image = ./images/jmusicbot.nix;
      restart = "always";

      volumes = [
        "${rwPath}/br/config.txt:/jmb/config/config.txt:ro"
        "${rwPath}/br/playlists:/jmb/config/playlists:rw"
      ];
    };
  };
}
