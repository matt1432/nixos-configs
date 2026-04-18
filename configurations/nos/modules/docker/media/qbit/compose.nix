{
  configPath,
  mainUID,
  mainGID,
  TZ,
  ...
}: {config, pkgs, ...}: let
  inherit (config.sops) secrets;

  rwPath = configPath + "/media/qbit";

  vue = let
    gen = import ./vuetorrent.nix;
  in
    pkgs.stdenv.mkDerivation {
      pname = "vuetorrent";
      inherit (gen) version;

      nativeBuildInputs = [pkgs.unzip];
      src = pkgs.fetchurl {
        inherit (gen) url hash;
      };

      postInstall = ''
        mkdir $out
        cp -a ./* $out
      '';
    };
in {
  virtualisation.docker.compose."qbit" = {
    services = {
      "gluetun" = {
        image = pkgs.callPackage ./images/gluetun.nix pkgs;
        restart = "always";

        ports = ["8080:8080"];
        volumes = ["${rwPath}/gluetun:/gluetun"];

        environment = {
          VPN_SERVICE_PROVIDER = "protonvpn";
          VPN_TYPE = "wireguard";
          PORT_FORWARD_ONLY = "on";
          VPN_PORT_FORWARDING = "on";
          VPN_PORT_FORWARDING_UP_COMMAND = ''/bin/sh -c 'wget -O- -nv --retry-connrefused --post-data "json={\"listen_port\":{{PORT}},\"current_network_interface\":\"{{VPN_INTERFACE}}\",\"random_port\":false,\"upnp\":false}" http://127.0.0.1:8080/api/v2/app/setPreferences' '';
          VPN_PORT_FORWARDING_DOWN_COMMAND = ''/bin/sh -c 'wget -O- -nv --retry-connrefused --post-data "json={\"listen_port\":0,\"current_network_interface\":\"lo\"}" http://127.0.0.1:8080/api/v2/app/setPreferences' '';
        };

        envFile = [secrets.vpn-docker.path];

        cap_add = ["NET_ADMIN"];
        devices = ["/dev/net/tun:/dev/net/tun"];
      };

      "qbittorrent" = {
        image = pkgs.callPackage ./images/qbit.nix pkgs;
        restart = "always";

        hostname = null;

        environment = {
          PUID = mainUID;
          PGID = mainGID;
          inherit TZ;
          WEBUI_PORT = "8080";
        };

        volumes = [
          "${vue}:/webui"
          "${rwPath}/config:/config"
          "/data:/data"
        ];

        network_mode = "service:gluetun";
      };
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
