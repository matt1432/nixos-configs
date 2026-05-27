{
  configPath,
  mainUID,
  mainGID,
  TZ,
  ...
}: {
  config,
  pkgs,
  ...
}: let
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
        mkdir "$out"
        cp -a ./* "$out"
      '';
    };
in {
  virtualisation.docker.compose."qbit" = {
    networks.proxy_net = {external = true;};

    services = {
      "gluetun" = {
        image = pkgs.callPackage ./images/gluetun.nix pkgs;
        restart = "always";

        ports = [
          "8080:8080" # qbit
          "5600:5600" # airdcpp
        ];
        volumes = ["${rwPath}/gluetun:/gluetun"];

        environment = {
          VPN_SERVICE_PROVIDER = "protonvpn";
          VPN_TYPE = "wireguard";
          PORT_FORWARD_ONLY = "on";
          VPN_PORT_FORWARDING = "on";
          VPN_PORT_FORWARDING_UP_COMMAND = ''/bin/sh -c 'wget -O- -nv --retry-connrefused --post-data "json={\"listen_port\":{{PORT}},\"current_network_interface\":\"{{VPN_INTERFACE}}\",\"random_port\":false,\"upnp\":false}" http://127.0.0.1:8080/api/v2/app/setPreferences' '';
          VPN_PORT_FORWARDING_DOWN_COMMAND = ''/bin/sh -c 'wget -O- -nv --retry-connrefused --post-data "json={\"listen_port\":0,\"current_network_interface\":\"lo\"}" http://127.0.0.1:8080/api/v2/app/setPreferences' '';

          # For airdcpp-gluetun-sync
          HTTP_CONTROL_SERVER_AUTH_DEFAULT_ROLE=''{"auth":"none"}'';
        };

        envFile = [secrets.vpn-docker.path];

        cap_add = ["NET_ADMIN"];
        devices = ["/dev/net/tun:/dev/net/tun"];

        networks = ["proxy_net"];
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

        networkMode = "service:gluetun";
      };

      "airdcpp" = {
        image = pkgs.callPackage ./images/airdcpp.nix pkgs;
        restart = "always";

        hostname = null;

        environment = {
          PUID = mainUID;
          PGID = mainGID;
          inherit TZ;
        };

        volumes = [
          "${rwPath}/airdcpp:/.airdcpp"
          "/data/downloads/dcpp/downloads:/Downloads"
          "/data/downloads/dcpp/share:/Share"
        ];

        networkMode = "service:gluetun";
      };

      "airdcpp-gluetun-sync" = {
        image = pkgs.callPackage ./images/airdcpp-gluetun-sync.nix pkgs;

        environment = {
          inherit TZ;
          AIRDCPP_ADDR = "http://gluetun:5600";
          GTN_ADDR = "http://gluetun:8000";
        };

        dependsOn = [
          "airdcpp"
          "gluetun"
        ];

        networks = ["proxy_net"];
      };
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
