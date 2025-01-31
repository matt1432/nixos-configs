rwDataDir: {pkgs, ...}: {
  virtualisation.docker.compose."hauk" = {
    networks.proxy_net = {external = true;};

    services."hauk" = {
      image = pkgs.callPackage ./images/hauk.nix pkgs;
      restart = "always";
      ports = ["3003:80"];
      networks = ["proxy_net"];

      volumes = ["${./config.php}:/etc/hauk/config.php:ro"];
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
