{...}: {
  arion.projects."hauk"."hauk" = {
    image = ./images/hauk.nix;
    restart = "always";
    ports = ["3003:80"];

    volumes = ["${./config.php}:/etc/hauk/config.php:ro"];
  };
}
