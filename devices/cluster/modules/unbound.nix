{config, ...}: let
  inherit (config.vars) mainUser hostName;
in {
  # https://github.com/MatthewVance/unbound-docker-rpi/issues/4#issuecomment-1001879602
  boot.kernel.sysctl."net.core.rmem_max" = 1048576;

  users.users.${mainUser}.extraGroups = ["unbound"];

  services.unbound = {
    enable = true;
    enableRootTrustAnchor = true;
    resolveLocalQueries = false;

    settings = {
      server = {
        interface = ["127.0.0.1"];
        port = 5335;

        # Custom DNS
        local-zone = [
          "pve.nelim.org redirect"
          "headscale.nelim.org redirect"
          "git.nelim.org redirect"
          "mc.nelim.org transparent"
          "cv.nelim.org transparent"
          "mc2.nelim.org transparent"
          "ota.nelim.org redirect"
          "nelim.org redirect"
        ];
        local-data = let
          caddyIp =
            if hostName == "thingone"
            then "100.64.0.8"
            else "100.64.0.9";
        in [
          "\"pve.nelim.org IN A 100.64.0.4\""

          "\"headscale.nelim.org. IN A 24.200.126.219\""

          "\"git.nelim.org. IN A 24.200.126.219\""

          "\"mc.nelim.org IN A 100.64.0.7\""
          "\"_minecraft._tcp.mc.nelim.org. 180 IN SRV 0 0 25569 mc.nelim.org.\""

          "\"cv.nelim.org IN A 100.64.0.7\""
          "\"_minecraft._tcp.cv.nelim.org. 180 IN SRV 0 0 25566 cv.nelim.org.\""

          "\"mc2.nelim.org IN A 100.64.0.7\""
          "\"_minecraft._tcp.mc2.nelim.org. 180 IN SRV 0 0 25560 mc2.nelim.org.\""

          "\"ota.nelim.org. IN A 100.64.0.5\""

          "\"nelim.org 0 A ${caddyIp}\""
        ];

        do-ip4 = true;
        do-ip6 = false;
        prefer-ip6 = false;
        do-udp = true;
        do-tcp = true;

        # Performance
        prefetch = true;
        num-threads = 1;

        private-address = [
          "172.16.0.0/12"
          "10.0.0.0/8"
          "100.64.0.0/8"
          "fd00::/8"
          "fe80::/10"
        ];

        # Default stuff
        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        edns-buffer-size = 1232;
        so-rcvbuf = "1m";
      };
    };
  };
}
