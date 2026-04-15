{
  config,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;

  wgPort = 51820;
  wgDns = "10.2.0.1";
  clientIP = "10.2.0.2";
  serverIP = "163.5.171.2";
in {
  networking.wireguard = {
    enable = true;

    interfaces = {
      wg0 = {
        interfaceNamespace = "wg";
        ips = ["${clientIP}/32"];

        listenPort = wgPort;

        generatePrivateKeyFile = false;
        privateKeyFile = secrets.vpn.path;

        peers = [
          {
            publicKey = "gU9CLkRxLUarj9+MtswvE/2Tvclx32w5aoSYeY3eEX8=";
            allowedIPs = ["0.0.0.0/0"];
            endpoint = "${serverIP}:${toString wgPort}";
          }
        ];
      };
    };
  };

  environment.etc."netns/wg/resolv.conf".text = "nameserver ${wgDns}";

  boot.kernelModules = ["ip_tables" "iptable_nat"];

  systemd.services = let
    joinWgNamespace = {
      bindsTo = ["netns@wg.service"];
      requires = ["network-online.target"];
      after = ["wireguard-wg0.service"];
      unitConfig.JoinsNamespaceOf = "netns@wg.service";
      serviceConfig = {
        NetworkNamespacePath = "/var/run/netns/wg";
        BindReadOnlyPaths = "/etc/netns/wg/resolv.conf:/etc/resolv.conf";
      };
    };

    mkPortRoute = service: port: {
      description = "Forward to ${service} in wireguard namespace";
      requires = ["${service}.service"];
      after = ["${service}.service"];
      partOf = ["${service}.service"];
      serviceConfig = {
        Restart = "on-failure";
        TimeoutStopSec = 300;
      };
      wantedBy = ["multi-user.target"];
      script = ''
        ${pkgs.iproute2}/bin/ip netns exec wg ${pkgs.iproute2}/bin/ip link set dev lo up
        ${pkgs.socat}/bin/socat tcp-listen:${port},fork,reuseaddr exec:'${pkgs.iproute2}/bin/ip netns exec wg ${pkgs.socat}/bin/socat STDIO "tcp-connect:${clientIP}:${port}"',nofork
      '';
    };
  in {
    # Create namespace for Wireguard
    # This allows us to isolate specific programs to Wireguard
    "netns@" = {
      description = "%I network namespace";
      before = ["network.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.iproute2}/bin/ip netns add %I";
        ExecStop = "${pkgs.iproute2}/bin/ip netns del %I";
      };
    };
    "wireguard-wg0".wants = ["netns@wg.service"];

    "qbittorrent" = joinWgNamespace;
    "qbittorrent-port-route" = mkPortRoute "qbittorrent" "8080";
  };
}
