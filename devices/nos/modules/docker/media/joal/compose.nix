{
  config,
  pkgs,
  ...
}: let
  inherit (config.khepri) rwDataDir;

  rwPath = rwDataDir + "/media/joal";
in {
  khepri.compositions."joal" = {
    networks.proxy_net = {external = true;};

    services."joal" = {
      image = import ./images/joal.nix pkgs;
      restart = "always";

      volumes = ["${rwPath}/data:/data"];
      extraHosts = ["lan.nelim.org:10.0.0.130"];
      ports = ["5656:5656"];

      cmd = [
        "--joal-conf=/data"
        "--spring.main.web-environment=true"
        "--server.port=5656"
        "--joal.ui.path.prefix=joal"
        "--joal.ui.secret-token=12345"
      ];
      networks = ["proxy_net"];
    };
  };
}
