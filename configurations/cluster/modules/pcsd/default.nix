{
  config,
  pcsd,
  ...
}: let
  inherit (config.sops) secrets;
in {
  imports = [pcsd.nixosModules.default];

  services.pcsd = {
    enable = true;
    enableWebUI = true;

    clusterName = "thingies";

    corosyncKeyFile = secrets.corosync.path;
    clusterUserPasswordFile = secrets.pcs-pass.path;

    virtualIps = [
      {
        id = "caddy-vip";
        ip = "10.0.0.130";
        interface = "eno1";
        group = "caddy-grp";
      }
    ];

    systemdResources = [
      {
        systemdName = "unbound";
        enable = true;
        group = "caddy-grp";
      }

      {
        systemdName = "blocky";
        enable = true;
        group = "caddy-grp";
      }

      {
        systemdName = "headscale";
        enable = true;
        group = "caddy-grp";
      }

      {
        systemdName = "caddy";
        enable = true;
        group = "caddy-grp";
      }

      {
        systemdName = "whoogle-search";
        enable = true;
        group = "caddy-grp";
      }
    ];

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
