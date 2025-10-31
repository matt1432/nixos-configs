{
  config,
  mainUser,
  ...
}: let
  inherit (config.networking) hostName;

  clusterIP = (builtins.head config.services.pcsd.virtualIps).ip;
  wanIP = "166.62.184.216";
in {
  users.users.${mainUser}.extraGroups = ["headscale"];

  services.headscale = {
    enable = true;

    settings = {
      server_url = "https://headscale.nelim.org";

      listen_addr = "${clusterIP}:8085";
      metrics_listen_addr = "127.0.0.1:9090";

      grpc_listen_addr = "0.0.0.0:50443";
      grpc_allow_insecure = false;

      prefixes = {
        v4 = "100.64.0.0/10";
        v6 = "fd7a:115c:a1e0::/48";
      };

      disable_check_updates = true;
      ephemeral_node_inactivity_timeout = "30m";

      unix_socket = "/run/headscale/headscale.sock";
      unix_socket_permission = "0770";

      database = {
        type = "sqlite";
        sqlite.path = "/var/lib/headscale/db.sqlite";
      };

      private_key_path = "/var/lib/headscale/private.key";
      noise.private_key_path = "/var/lib/headscale/noise_private.key";

      dns = let
        caddyIp =
          if hostName == "thingone"
          then "100.64.0.8"
          else "100.64.0.9";

        publicDNS = [
          "1.1.1.1"
          "1.0.0.1"
          "2606:4700:4700::1111"
          "2606:4700:4700::1001"
        ];
      in {
        magic_dns = false;
        override_local_dns = true;

        nameservers = {
          global = [caddyIp] ++ publicDNS;

          split = {
            "headscale.nelim.org" = publicDNS;

            "nelim.org" = [caddyIp];
          };
        };
      };

      log = {
        format = "text";
        level = "info";
      };

      derp = {
        auto_update_enable = true;
        update_frequency = "24h";

        server = {
          enabled = true;
          stun_listen_addr = "${clusterIP}:3479";
          private_key_path = "/var/lib/headscale/derp_server_private.key";

          region_id = 995;
          region_code = "mon";
          region_name = "montreal";

          ipv4 = wanIP;
        };
      };
    };
  };
}
