{
  config,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;
in {
  networking.wireguard = {
    enable = true;

    interfaces = {
      wg0 = {
        interfaceNamespace = "wg";
        ips = ["10.2.0.2/32"];

        listenPort = 51820;

        generatePrivateKeyFile = false;
        privateKeyFile = secrets.vpn.path;

        peers = [
          {
            publicKey = "aQ2NoOYEObG9tDMwdc4VxK6hjW+eA0PLfgbH7ffmagU=";
            allowedIPs = ["0.0.0.0/0"];
            endpoint = "146.70.198.2:51820";
          }
        ];
      };
    };
  };

  systemd.services = let
    joinWgNamespace = {
      bindsTo = [ "netns@wg.service" ];
      requires = [ "network-online.target" ];
      after = [ "wireguard-wg0.service" ];
      unitConfig.JoinsNamespaceOf = "netns@wg.service";
      serviceConfig.NetworkNamespacePath = "/var/run/netns/wg";
    };

    mkPortRoute = service: port: {
      description = "Forward to ${service} in wireguard namespace";
      requires = ["${service}.service"];
      after = ["${service}.service"];
      serviceConfig = {
        Restart = "on-failure";
        TimeoutStopSec = 300;
      };
      wantedBy = ["multi-user.target"];
      script = ''
        ${pkgs.iproute2}/bin/ip netns exec wg ${pkgs.iproute2}/bin/ip link set dev lo up
        ${pkgs.socat}/bin/socat tcp-listen:${port},fork,reuseaddr exec:'${pkgs.iproute2}/bin/ip netns exec wg ${pkgs.socat}/bin/socat STDIO "tcp-connect:10.2.0.2:${port}"',nofork
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
  };
}
