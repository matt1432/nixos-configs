{
  config,
  pcsd,
  ...
}: let
  inherit (config.sops) secrets;
in {
  imports = [
    pcsd.nixosModules.default

    ./blocky.nix
    ./caddy.nix
    ./headscale
    ./nfs-client.nix
    ./unbound.nix
  ];

  services.pcsd = {
    enable = true;
    enableBinaryCache = true;

    clusterName = "thingies";

    corosyncKeyFile = secrets.corosync.path;
    clusterUserPasswordFile = secrets.PASSWORD.path;

    virtualIps = {
      "caddy-vip" = {
        ip = "10.0.0.130";
        interface = "eno1";
        group = "caddy-grp";
      };
    };

    systemdResources = {
      "unbound" = {
        enable = true;
        group = "caddy-grp";
        startAfter = ["caddy-vip"];
      };

      "blocky" = {
        enable = true;
        group = "caddy-grp";
        startAfter = ["unbound"];
      };

      "caddy" = {
        enable = true;
        group = "caddy-grp";
        startAfter = ["blocky"];
      };

      "headscale" = {
        enable = true;
        group = "caddy-grp";
        startAfter = ["caddy"];
      };
    };

    nodes = [
      {
        name = "thingone";
        nodeid = 1;
        ring_addrs = ["10.0.0.244"];
      }
      {
        name = "thingtwo";
        nodeid = 2;
        ring_addrs = ["10.0.0.159"];
      }
    ];
  };
}
