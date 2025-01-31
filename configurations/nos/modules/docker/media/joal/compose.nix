rwDataDir: {pkgs, ...}: let
  rwPath = rwDataDir + "/media/joal";
in {
  virtualisation.docker.compose."joal" = {
    networks.proxy_net = {external = true;};

    services."joal" = {
      image = pkgs.callPackage ./images/joal.nix pkgs;
      restart = "always";

      volumes = ["${rwPath}/data:/data"];
      ports = ["5656:5656"];

      command = [
        "--joal-conf=/data"
        "--spring.main.web-environment=true"
        "--server.port=5656"
        "--joal.ui.path.prefix=joal"
        "--joal.ui.secret-token=12345"
      ];
      networks = ["proxy_net"];
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
