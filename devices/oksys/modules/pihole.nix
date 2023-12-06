{pihole, ...}: {
  imports = [pihole.nixosModules.default];

  services.pihole = {
    enable = true;

    dnsPort = 53;
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

      # Declaratively set the DNS settings
      # in Settings -> DNS -> Interface settings
      dnsmasq.extraConfig = ''
        interface=tailscale0
        except-interface=nonexisting
      '';

      # Handle it with unbound
      dns.upstreamServers = [
        "127.0.0.1#5335"
        "127.0.0.1#5335"
      ];
    };
  };
}
