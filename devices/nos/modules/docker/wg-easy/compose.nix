{
  config,
  pkgs,
  ...
}: let
  inherit (config.khepri) rwDataDir;

  rwPath = rwDataDir + "/wg-easy";
in {
  khepri.compositions."wg-easy" = {
    networks.proxy_net = {external = true;};

    services."wg-easy" = {
      image = import ./images/wg-easy.nix pkgs;
      restart = "always";
      privileged = true;

      capAdd = [
        "NET_ADMIN"
        "SYS_MODULE"
      ];

      sysctls = [
        "net.ipv4.ip_forward=1"
        "net.ipv4.conf.all.src_valid_mark=1"
      ];

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

      networks = ["proxy_net"];
    };
  };
}
