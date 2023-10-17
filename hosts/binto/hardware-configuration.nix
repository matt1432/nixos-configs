{ config, lib, modulesPath, pkgs, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];

    consoleLogLevel = 0;

    initrd = {
      verbose = false;
      systemd.enable = true;
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    };

    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 2;

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        extraConfig = ''
          set timeout_style=hidden
        '';
        splashImage = null;
      };
    };
  };

  fileSystems = {
    "/" ={
      device = "/dev/disk/by-uuid/560976b6-85e0-44ca-bb73-e15a78e9c449";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/1407-A10C";
      fsType = "vfat";
    };
  };

  zramSwap.enable = true;
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    uinput.enable = true;
  };

  virtualisation = {
    libvirtd.enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
