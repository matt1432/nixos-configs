{pkgs, ...}: {
  khepri.compositions."hauk" = {
    networks.proxy_net = {external = true;};

    services."hauk" = {
      image = import ./images/hauk.nix pkgs;
      restart = "always";
      ports = ["3003:80"];
      networks = ["proxy_net"];

      volumes = ["${./config.php}:/etc/hauk/config.php:ro"];
    };
  };
}
