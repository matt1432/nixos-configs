{modulesPath, ...}: {
  nixpkgs.hostPlatform = "x86_64-linux";
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  jovian = {
    steamos.useSteamOSConfig = true;

    devices.steamdeck = {
      enable = true;
      enableGyroDsuService = true;
    };
    hardware.has.amd.gpu = true;
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;

    systemd-boot = {
      enable = true;
      configurationLimit = 30;
    };
  };

  virtualisation.waydroid.enable = true;

  # TODO: add auto-generated stuff

  # Placeholder
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/6ae4d722-dacf-485a-8d29-b276f540dc91";
      fsType = "btrfs";
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };
  };
}
