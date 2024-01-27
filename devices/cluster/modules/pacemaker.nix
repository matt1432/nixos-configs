{
  config,
  pacemaker,
  ...
}: let
  inherit (config.sops) secrets;
in {
  imports = [
    pacemaker.nixosModules.default

    ./blocky.nix
    ./caddy.nix
    ./headscale
    ./nfs-client.nix
    ./unbound.nix
  ];

  services.pacemaker = {
    enable = true;
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
      "caddy" = {
        enable = true;
        group = "caddy-grp";
        startAfter = ["caddy-vip"];
      };

      "unbound" = {
        enable = true;
        group = "caddy-grp";
        startAfter = ["caddy"];
      };

      "blocky" = {
        enable = true;
        group = "caddy-grp";
        startAfter = ["unbound"];
      };

      "headscale" = {
        enable = true;
        group = "caddy-grp";
        startAfter = ["blocky"];
      };
    };

    nodes = [
      {
        nodeid = 1;
        name = "thingone";
        ring_addrs = ["10.0.0.244"];
      }
      {
        nodeid = 2;
        name = "thingtwo";
        ring_addrs = ["10.0.0.159"];
      }
    ];
  };
}
