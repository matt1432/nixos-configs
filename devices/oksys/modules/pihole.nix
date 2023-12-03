{pihole, ...}: {
  imports = [pihole.nixosModules.default];

  #TODO: set the whole thing up
  services.pihole = {
    enable = true;

    dnsPort = 5335;
    webPort = 8080;

    piholeConfig = {
      ftl = {
        LOCAL_IPV4 = "127.0.0.1";
      };

      web = {
        virtualHost = "pi.hole";
        password = "password";
      };
    };
  };
}
