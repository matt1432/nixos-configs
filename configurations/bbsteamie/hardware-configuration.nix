{
  config,
  jovian,
  modulesPath,
  pkgs,
  ...
}: {
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    jovian.nixosModules.default
  ];

  jovian = {
    steamos.useSteamOSConfig = true;

    devices.steamdeck = {
      enable = true;
      enableGyroDsuService = true;
    };
    hardware.has.amd.gpu = true;
    devices.steamdeck.autoUpdate = true;
  };
  environment.systemPackages = with pkgs; [steamdeck-firmware xorg.xwininfo];

  nixpkgs.overlays = [
    (final: prev: {
      steamos-manager = prev.steamos-manager.overrideAttrs (o: {
        postPatch = ''
          ${o.postPatch or ""}
          substituteInPlace ./data/user/steamos-manager.service --replace-fail \
            "EnvironmentFile=%t/gamescope-environment" ""
        '';
      });
    })
  ];

  boot = {
    kernelModules = ["kvm-amd"];
    initrd.availableKernelModules = ["nvme" "xhci_pci" "usbhid" "sdhci_pci"];

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        configurationLimit = 30;
      };
    };
  };

  virtualisation.waydroid.enable = true;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };

  swapDevices = [
    {
      device = "/.swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
}
