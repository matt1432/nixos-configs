{pkgs, ...}: {
  imports = [
    ./options.nix
    ../corosync.nix

    ../blocky.nix
    ../caddy.nix
    ../headscale
    ../unbound.nix
  ];

  # TODO: update script
  services.pacemaker = {
    enable = true;

    resources = {
      "blocky" = {
        enable = true;
        dependsOn = ["unbound"];
      };

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

      "headscale" = {
        enable = true;
        dependsOn = ["caddy"];
      };

      "unbound" = {
        enable = true;
        dependsOn = ["caddy"];
      };
    };
  };

  # NFS client setup
  services.rpcbind.enable = true;
  boot.supportedFilesystems = ["nfs"];
  environment.systemPackages = with pkgs; [nfs-utils];

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
