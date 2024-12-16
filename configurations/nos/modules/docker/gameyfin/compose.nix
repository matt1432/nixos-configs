{
  config,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;
in {
  khepri.compositions."gameyfin" = {
    networks.proxy_net = {external = true;};

    services."gameyfin" = {
      image = import ./images/gameyfin.nix pkgs;
      restart = "always";
      user = "1000:1000";

      environmentFiles = [secrets.gameyfin.path];
      environment.GAMEYFIN_USER = "mathis";

      volumes = [
        "/data/games:/opt/gameyfin-library"
      ];

      expose = ["8080"];
      ports = ["8074:8080"];
      networks = ["proxy_net"];
    };
  };
}
