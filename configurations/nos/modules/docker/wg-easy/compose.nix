{configPath, ...}: {pkgs, ...}: let
  rwPath = configPath + "/wg-easy";
in {
  virtualisation.docker.compose."wg-easy" = {
    networks.proxy_net = {external = true;};

    services."wg-easy" = {
      image = pkgs.callPackage ./images/wg-easy.nix pkgs;
      restart = "always";
      privileged = true;

      cap_add = [
        "NET_ADMIN"
        "SYS_MODULE"
      ];

      sysctls = [
        "net.ipv4.ip_forward=1"
        "net.ipv4.conf.all.src_valid_mark=1"
      ];

      environment = {
        WG_HOST = "nelim.org";
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

  # For accurate stack trace
  _file = ./compose.nix;
}
