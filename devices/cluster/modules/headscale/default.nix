{
  config,
  headscale,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) readFile;
  inherit (lib) mkAfter mkForce;
  inherit (pkgs.writers) writeYAML;

  inherit (config.vars) mainUser hostName;
  headscale-flake = headscale.packages.${pkgs.system}.headscale;

  clusterIP = config.services.pcsd.virtualIps.caddy-vip.ip;
in {
  environment.systemPackages = [headscale-flake];
  users.users.${mainUser}.extraGroups = ["headscale"];

  home-manager.users.${mainUser}
    .programs.bash.bashrcExtra = mkAfter (readFile ./completion.bash);

  services.headscale = {
    enable = true;
    package = headscale-flake;
  };

  # Takes way too long to shutdown
  systemd.services."headscale".serviceConfig.TimeoutStopSec = "5";

  environment.etc."headscale/config.yaml".source = mkForce (
    writeYAML "headscale.yaml" {
      server_url = "https://headscale.nelim.org";
      listen_addr = "${clusterIP}:8085";
      prefixes = {
        v4 = "100.64.0.0/10";
        v6 = "fd7a:115c:a1e0::/48";
      };
      metrics_listen_addr = "127.0.0.1:9090";
      grpc_listen_addr = "0.0.0.0:50443";
      grpc_allow_insecure = false;
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

      dns_config = let
        caddyIp =
          if hostName == "thingone"
          then "100.64.0.8"
          else "100.64.0.9";
      in {
        magic_dns = false;
        override_local_dns = true;
        nameservers = [caddyIp];
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
        };
      };
    }
  );
}
