{pkgs, ...}: {
  khepri.compositions."hauk".services."hauk" = {
    image = import ./images/hauk.nix pkgs;
    restart = "always";
    ports = ["3003:80"];

    volumes = ["${./config.php}:/etc/hauk/config.php:ro"];
  };
}
