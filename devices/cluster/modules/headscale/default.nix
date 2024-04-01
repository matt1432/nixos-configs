{
  config,
  headscale,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) readFile;
  inherit (lib) mkAfter mkOption;

  inherit (config.vars) mainUser hostName;
  headscale-flake = headscale.packages.${pkgs.system}.headscale;

  clusterIP = config.services.pcsd.virtualIps.caddy-vip.ip;
in {
  # FIXME: wait for nixpkgs to reach this : https://github.com/juanfont/headscale/commit/94b30abf56ae09d82a1541bbc3d19557914f9b27
  options.services.headscale.settings.db_type = mkOption {
    type = lib.types.enum ["sqlite" "postgres"];
  };

  config = {
    environment.systemPackages = [headscale-flake];
    users.users.${mainUser}.extraGroups = ["headscale"];

    home-manager.users.${mainUser}
    .programs.bash.bashrcExtra = mkAfter (readFile ./completion.bash);

    services.headscale = {
      enable = true;
      package = headscale-flake;

      address = clusterIP;
      port = 8085;

      settings = {
        server_url = "https://headscale.nelim.org";
        ip_prefixes = ["100.64.0.0/10"];
        metrics_listen_addr = "127.0.0.1:9090";
        grpc_listen_addr = "0.0.0.0:50443";
        grpc_allow_insecure = false;
        disable_check_updates = true;
        unix_socket_permission = "0770";

        db_type = "sqlite";
        db_path = "/var/lib/headscale/db.sqlite";
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

        derp = {
          urls = [];

          server = {
            enabled = true;
            stun_listen_addr = "${clusterIP}:3479";
            private_key_path = "/var/lib/headscale/derp_server_private.key";

            region_id = 995;
            region_code = "mon";
            region_name = "montreal";
          };
        };
      };
    };
  };
}
