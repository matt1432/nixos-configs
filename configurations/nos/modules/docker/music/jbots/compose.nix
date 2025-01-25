{
  config,
  pkgs,
  self,
  ...
}: let
  inherit (self.packages.${pkgs.system}) jmusicbot;
  inherit (config.khepri) rwDataDir;

  rwPath = rwDataDir + "/music/jbots";
  image = import ./images/jmusicbot.nix {inherit pkgs jmusicbot;};
in {
  khepri.compositions."jbots" = {
    networks.proxy_net = {external = true;};

    services = {
      "musicbot_be" = {
        containerName = "be";
        restart = "always";
        inherit image;

        volumes = [
          "${rwPath}/be:/jmb/config:rw"
        ];
        networks = ["proxy_net"];
      };

      "musicbot_br" = {
        containerName = "br";
        restart = "always";
        inherit image;

        volumes = [
          "${rwPath}/br:/jmb/config:rw"
        ];
        networks = ["proxy_net"];
      };
    };
  };
}
