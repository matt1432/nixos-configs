{
  config,
  pkgs,
  ...
}: let
  inherit (config.khepri) rwDataDir;

  rwPath = rwDataDir + "/music/jbots";
in {
  khepri.compositions."jbots" = {
    networks.proxy_net = {external = true;};

    services = {
      "musicbot_be" = {
        containerName = "be";
        image = import ./images/jmusicbot.nix pkgs;
        restart = "always";

        volumes = [
          "${rwPath}/be/config.txt:/jmb/config/config.txt:ro"
          "${rwPath}/be/playlists:/jmb/config/playlists:rw"
        ];
        networks = ["proxy_net"];
      };

      "musicbot_br" = {
        containerName = "br";
        image = import ./images/jmusicbot.nix pkgs;
        restart = "always";

        volumes = [
          "${rwPath}/br/config.txt:/jmb/config/config.txt:ro"
          "${rwPath}/br/playlists:/jmb/config/playlists:rw"
        ];
        networks = ["proxy_net"];
      };
    };
  };
}
