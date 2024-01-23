{pkgs, ...}: {
  imports = [
    ./options.nix
    ../corosync.nix

    ../caddy.nix
  ];

  # TODO: update script
  services = {
    pacemaker = {
      enable = true;

      resources = {
        "caddy" = {
          enable = true;
          virtualIps = [
            {
              id = "main";
              interface = "eno1";
              ip = "10.0.0.130";
            }
          ];
        };
      };
    };

    rpcbind.enable = true; # needed for NFS
  };

  environment.systemPackages = with pkgs; [nfs-utils];

  systemd.mounts = [
    {
      type = "nfs";
      mountConfig = {
        Options = "noatime";
      };
      what = "servivi:/caddy";
      where = "/var/lib/caddy";
      requiredBy = ["caddy.service"];
    }
  ];
}
