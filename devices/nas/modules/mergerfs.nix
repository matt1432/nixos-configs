{pkgs, ...}: let
  fsPkgs = with pkgs; [mergerfs cifs-utils];
in {
  system.fsPackages = fsPkgs;
  environment.systemPackages = fsPkgs;

  fileSystems."/data" = {
    device = "//10.0.0.121/public";
    fsType = "cifs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "uid=1000"
      "gid=1000"
      "credentials=${builtins.toFile "creds.txt" ''
        username=root
        domain=WORKGROUP
      ''}"
    ];
  };

  /*
  fileSystems = {
    "MergerFS Data" = {
      mountPoint = "/data";
      fsType = "fuse.mergerfs";
      device = "/mnt/drives/?tb*";
      options = [
        "cache.files=partial"
        "allow_other"
        "category.create=lfs"
        "minfreespace=50G"
        "fsname=mergerfs"
      ];
    };

    "3tb-1" = {
      mountPoint = "/mnt/drives/3tb1";
      fsType = "ext4";
      device = "/dev/disk/by-id/ata-WDC_WD30EFRX-68EUZN0_WD-WMC4N1236473-part1";
    };

    "3tb-2" = {
      mountPoint = "/mnt/drives/3tb2";
      fsType = "ext4";
      device = "/dev/disk/by-id/ata-WDC_WD30EFRX-68EUZN0_WD-WMC4N1233153-part1";
    };

    "4tb-1" = {
      mountPoint = "/mnt/drives/4tb1";
      fsType = "ext4";
      device = "/dev/disk/by-id/ata-WDC_WD40EZAZ-19SF3B0_WD-WX32D81DE8RD-part1";
    };

    "4tb-2" = {
      mountPoint = "/mnt/drives/4tb2";
      fsType = "ext4";
      device = "/dev/disk/by-id/ata-WDC_WD40EZAZ-19SF3B0_WD-WX32D81DE6Z0-part1";
    };

    "8tb-1" = {
      mountPoint = "/mnt/drives/8tb1";
      fsType = "ext4";
      device = "/dev/disk/by-id/ata-WDC_WD8003FFBX-68B9AN0_VAJ99UDL-part1";
    };

    "8tb-2 parity0" = {
      mountPoint = "/mnt/drives/parity0";
      fsType = "ext4";
      device = "/dev/disk/by-id/ata-WDC_WD8003FFBX-68B9AN0_VDGL4HZD-part1";
    };

    "8tb-3 parity1" = {
      mountPoint = "/mnt/drives/parity1";
      fsType = "ext4";
      device = "/dev/disk/by-id/ata-WDC_WD80EFZZ-68BTXN0_WD-CA13WUYK-part1";
    };

    "8tb-4" = {
      mountPoint = "/mnt/drives/8tb4";
      fsType = "ext4";
      device = "/dev/disk/by-id/ata-WDC_WD80EAZZ-00BKLB0_WD-CA1AVU7K-part1";
    };

    "8tb-5" = {
      mountPoint = "/mnt/drives/8tb5";
      fsType = "ext4";
      device = "/dev/disk/by-id/ata-WDC_WD80EAZZ-00BKLB0_WD-CA1GN0GK-part1";
    };
  };
  */
}
