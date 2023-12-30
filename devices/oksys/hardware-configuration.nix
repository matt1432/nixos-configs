{
  config,
  modulesPath,
  ...
}: {
  nixpkgs.hostPlatform = "x86_64-linux";
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  services.logind = {
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };

  boot = {
    loader = {
      timeout = 2;

      grub = {
        enable = true;
        device = "/dev/sda";
      };
    };
    initrd.availableKernelModules = [
      "uhci_hcd"
      "ehci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };
  };

  zramSwap.enable = true;

  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
}
