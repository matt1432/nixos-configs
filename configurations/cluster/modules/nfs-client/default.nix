{pkgs, ...}: {
  # NFS client setup
  services.rpcbind.enable = true;
  boot.supportedFilesystems = ["nfs"];
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) nfs-utils;
  };

  systemd.mounts = let
    host = "10.0.0.249";
  in [
    {
      type = "nfs";
      mountConfig = {
        Options = "noatime";
      };
      what = "${host}:/caddy";
      where = "/var/lib/caddy";
      requiredBy = ["caddy.service"];
    }

    {
      type = "nfs";
      mountConfig = {
        Options = "noatime";
      };
      what = "${host}:/headscale";
      where = "/var/lib/headscale";
      requiredBy = ["headscale.service"];
    }
  ];
}
