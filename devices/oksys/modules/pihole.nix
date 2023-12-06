{pihole, ...}: {
  imports = [pihole.nixosModules.default];

  services.pihole = {
    enable = true;

    dnsPort = 5353;
    webPort = 8080;

    piholeConfig = {
      ftl = {
        # Defaults
        PRIVACYLEVEL = "0";
        RATE_LIMIT = "1000/60";
      };

      interface = "tailscale0";

      web = {
        theme = "default-darker";
        virtualHost = "pi.hole";
        password = "password";
      };

      # Handle it with unbound
      dns.upstreamServers = [
        "127.0.0.1#5335"
        "127.0.0.1#5335"
      ];
    };
  };
}
