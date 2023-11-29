{
  headscale,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    headscale.packages.${pkgs.system}.headscale
  ];

  services.headscale = {
    enable = true;
    package = headscale.packages.${pkgs.system}.headscale;

    address = "127.0.0.1";
    port = 8085;

    settings = {
      server_url = "https://headscale.nelim.org";
      ip_prefixes = ["100.64.0.0/10"];
      metrics_listen_addr = "127.0.0.1:9090";
      grpc_listen_addr = "0.0.0.0:50443";
      grpc_allow_insecure = false;
      disable_check_updates = true;

      db_type = "sqlite3";
      db_path = "/var/lib/headscale/db.sqlite";
      private_key_path = "/var/lib/headscale/private.key";
      noise.private_key_path = "/var/lib/headscale/noise_private.key";

      dns_config = {
        magic_dns = false;
        override_local_dns = true;
        nameservers = ["100.64.0.1"];
      };

      derp = {
        urls = [];

        server = {
          enabled = true;
          stun_listen_addr = "0.0.0.0:3479";
          private_key_path = "/var/lib/headscale/derp_server_private.key";

          region_id = 995;
          region_code = "mon";
          region_name = "montreal";
        };
      };
    };
  };
}
