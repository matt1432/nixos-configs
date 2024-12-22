{
  config,
  lib,
  mainUser,
  ...
}: let
  inherit (lib) foldl isList mapAttrsToList mergeAttrsWithFunc remove unique;
  mergeAttrsList = list:
    foldl (mergeAttrsWithFunc (a: b:
      if isList a && isList b
      then unique (a ++ b)
      else b)) {}
    list;

  inherit (config.networking) hostName;

  serviviIP = "100.64.0.7";
  caddyIp =
    if hostName == "thingone"
    then "100.64.0.8"
    else "100.64.0.9";
in {
  # https://github.com/MatthewVance/unbound-docker-rpi/issues/4#issuecomment-1001879602
  boot.kernel.sysctl."net.core.rmem_max" = 1048576;

  users.users.${mainUser}.extraGroups = ["unbound"];

  services.unbound = {
    enable = true;
    enableRootTrustAnchor = true;
    resolveLocalQueries = false;

    settings = {
      server = let
        mkLocalEntry = domain: ip: {
          local-zone = ["${domain} redirect"];
          local-data = ["\"${domain} IN A ${ip}\""];
        };

        mkMinecraftEntry = domain: port: {
          local-zone = ["${domain} transparent"];
          local-data = [
            "\"${domain} IN A ${serviviIP}\""
            "\"_minecraft._tcp.${domain}. 180 IN SRV 0 0 ${toString port} ${domain}.\""
          ];
        };

        forceResolveEntry = domain: {
          local-zone = ["${domain} always_transparent"];
        };

        publicApps = remove "nelim.org" (mapAttrsToList (n: v: v.hostName) config.services.caddy.virtualHosts);
      in
        mergeAttrsList (
          [(mkLocalEntry "cache-apt.nelim.org" "100.64.0.10")]
          ++ (map forceResolveEntry publicApps)
          ++ [
            (mkMinecraftEntry "mc.nelim.org" 25569)
            (mkMinecraftEntry "mc2.nelim.org" 25560)
            (mkMinecraftEntry "cv.nelim.org" 25566)

            (mkLocalEntry "nelim.org" caddyIp)

            {
              interface = ["127.0.0.1"];
              port = 5335;

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
            }
          ]
        );
    };
  };
}
