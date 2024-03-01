{config, ...}: let
  inherit (config.arion) rwDataDir;

  rwPath = rwDataDir + "/media/joal";
in {
  arion.projects."joal"."joal" = {
    image = ./images/joal.nix;
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
  };
}
