{
  config,
  modulesPath,
  pkgs,
  ...
}: {
  nixpkgs.hostPlatform = "x86_64-linux";
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;

    kernelModules = ["kvm-amd"];

    # Zenpower for ryzen cpu monitoring
    extraModulePackages = builtins.attrValues {
      # NOTE: https://nixpkgs-tracker.ocfox.me/?pr=576565
      zenpower = let
        inherit (config.boot.kernelPackages) kernel kernelModuleMakeFlags;
      in
        config.boot.kernelPackages.zenpower.overrideAttrs (o: {
          makeFlags =
            kernelModuleMakeFlags
            ++ [
              "KERNEL_BUILD=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
              "INSTALL_MOD_PATH=${placeholder "out"}"
              "INSTALL_MOD_DIR=kernel/drivers/hwmon/zenpower"
              "INSTALL_MOD_STRIP=1"
              "DEPMOD=true"
            ];

          installTargets = ["modules_install"];

          installFlags = [
            "-C"
            "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
            "M=$(PWD)"
          ];
          installPhase = "";
        });
    };

    blacklistedKernelModules = ["k10temp"];

    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];

    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 2;

      systemd-boot = {
        enable = true;
        consoleMode = "max";
        configurationLimit = 30;
      };
    };

    # Support building binaries for arm64
    binfmt.emulatedSystems = ["aarch64-linux"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "btrfs";
    };

    # sudo btrfs subvolume create /@swap
    "/swap" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "btrfs";
      options = ["subvol=@swap"];
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 16 * 1024;
    }
  ];

  zramSwap.enable = true;

  hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
}
