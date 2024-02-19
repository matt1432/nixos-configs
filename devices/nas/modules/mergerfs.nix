{
  config,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;

  fsPkgs = with pkgs; [fuse mergerfs sshfs];

  sshfsOpts = [
    "IdentityFile=${secrets.sshfs.path}"

    "allow_other" # for non-root access
    "_netdev" # requires network to mount
    "x-systemd.automount" # mount on demand

    # Handle connection drops better
    "ServerAliveInterval=15"
    "reconnect"
    "defaults"
  ];
in {
  programs.ssh.knownHosts = {
    "10.0.0.121".publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDs4eTQxAU+/B3B3AYXbTeRIZGk6lUKlykWrZZ07r3NMIJkleEE7i5KgW8QeeWVLFG8Thi4jyVferM7tPILA//Q6GXNDQ3ioYHExG33d/yIRGStD3rEizAv0LkDHavZ33VDNEOkBLQ22eeB7cCaQvsUoCbryo6w3mSQO5PDH9RE44XrOaSCbLvjhst5Z9gXPtrJsBcvOFUpdwz5gIHIqTFo6fQpmzxYkY5GrMaqMB75Xh2MQNkIZteC2MMPgIH9Vz+Q3CnzyiXEzoYaUtT0//sXnydagWWt9xf+KJ34Oz0r1Jtn2ihgJZmA7NrO5zATZVq6qQHdhry3xL1PpvY7U5Zx";
  };

  system.fsPackages = fsPkgs;
  environment.systemPackages = fsPkgs;

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
      fsType = "sshfs"; # "ext4";
      options = sshfsOpts;
      device = "root@10.0.0.121:/drives/3tb-1";
      # device = "/dev/disk/by-id/ata-WDC_WD30EFRX-68EUZN0_WD-WMC4N1236473-part1";
    };

    "3tb-2" = {
      mountPoint = "/mnt/drives/3tb2";
      fsType = "sshfs"; # "ext4";
      options = sshfsOpts;
      device = "root@10.0.0.121:/drives/3tb-2";
      # device = "/dev/disk/by-id/ata-WDC_WD30EFRX-68EUZN0_WD-WMC4N1233153-part1";
    };

    "4tb-1" = {
      mountPoint = "/mnt/drives/4tb1";
      fsType = "sshfs"; # "ext4";
      options = sshfsOpts;
      device = "root@10.0.0.121:/drives/4tb-1";
      # device = "/dev/disk/by-id/ata-WDC_WD40EZAZ-19SF3B0_WD-WX32D81DE8RD-part1";
    };

    "4tb-2" = {
      mountPoint = "/mnt/drives/4tb2";
      fsType = "sshfs"; # "ext4";
      options = sshfsOpts;
      device = "root@10.0.0.121:/drives/4tb-2";
      # device = "/dev/disk/by-id/ata-WDC_WD40EZAZ-19SF3B0_WD-WX32D81DE6Z0-part1";
    };

    "8tb-1" = {
      mountPoint = "/mnt/drives/8tb1";
      fsType = "sshfs"; # "ext4";
      options = sshfsOpts;
      device = "root@10.0.0.121:/drives/8tb-1";
      # device = "/dev/disk/by-id/ata-WDC_WD8003FFBX-68B9AN0_VAJ99UDL-part1";
    };

    "8tb-2 parity0" = {
      mountPoint = "/mnt/drives/parity0";
      fsType = "sshfs"; # "ext4";
      options = sshfsOpts;
      device = "root@10.0.0.121:/drives/parity0";
      # device = "/dev/disk/by-id/ata-WDC_WD8003FFBX-68B9AN0_VDGL4HZD-part1";
    };

    "8tb-3 parity1" = {
      mountPoint = "/mnt/drives/parity1";
      fsType = "sshfs"; # "ext4";
      options = sshfsOpts;
      device = "root@10.0.0.121:/drives/parity1";
      # device = "/dev/disk/by-id/ata-WDC_WD80EFZZ-68BTXN0_WD-CA13WUYK-part1";
    };

    "8tb-4" = {
      mountPoint = "/mnt/drives/8tb4";
      fsType = "sshfs"; # "ext4";
      options = sshfsOpts;
      device = "root@10.0.0.121:/drives/8tb-4";
      # device = "/dev/disk/by-id/ata-WDC_WD80EAZZ-00BKLB0_WD-CA1AVU7K-part1";
    };

    "8tb-5" = {
      mountPoint = "/mnt/drives/8tb5";
      fsType = "sshfs"; # "ext4";
      options = sshfsOpts;
      device = "root@10.0.0.121:/drives/8tb-5";
      # device = "/dev/disk/by-id/ata-WDC_WD80EAZZ-00BKLB0_WD-CA1GN0GK-part1";
    };
  };
}
