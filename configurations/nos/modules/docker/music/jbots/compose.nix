rwDataDir: {
  pkgs,
  self,
  ...
}: let
  inherit (self.packages.${pkgs.system}) jmusicbot;

  rwPath = rwDataDir + "/music/jbots";
  image = pkgs.callPackage ./images/jmusicbot.nix {inherit pkgs jmusicbot;};
in {
  virtualisation.docker.compose."jbots" = {
    networks.proxy_net = {external = true;};

    services = {
      "musicbot_be" = {
        container_name = "be";
        restart = "always";
        inherit image;

        volumes = [
          "${rwPath}/be:/jmb/config:rw"
        ];
        networks = ["proxy_net"];
      };

      "musicbot_br" = {
        container_name = "br";
        restart = "always";
        inherit image;

        volumes = [
          "${rwPath}/br:/jmb/config:rw"
        ];
        networks = ["proxy_net"];
      };
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
