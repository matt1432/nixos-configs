{config, ...}: let
  inherit (config.arion) rwDataDir;

  rwPath = rwDataDir + "/wg-easy";
in {
  arion.projects."wg-easy"."wg-easy" = {
    image = ./images/wg-easy.nix;
    restart = "always";
    privileged = true;

    capabilities = {
      NET_ADMIN = true;
      SYS_MODULE = true;
    };

    sysctls = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv4.conf.all.src_valid_mark" = 1;
    };

    dns = ["1.0.0.1"];

    environment = {
      WG_HOST = "166.62.179.208";
      WG_PORT = "51820";
      WG_DEFAULT_ADDRESS = "10.6.0.x";
      WG_DEFAULT_DNS = "1.0.0.1";
    };

    volumes = [
      "${rwPath}/data:/etc/wireguard"
    ];

    ports = [
      "53:51820/udp"
      "51822:51820/udp"
      "51821:51821/tcp"
    ];
  };
}
