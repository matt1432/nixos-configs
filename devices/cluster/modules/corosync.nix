{config, ...}: {
  environment.etc."corosync/authkey" = {
    source = config.sops.secrets.corosync.path;
  };

  services.corosync = {
    enable = true;
    clusterName = "thingies";

    nodelist = [
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
