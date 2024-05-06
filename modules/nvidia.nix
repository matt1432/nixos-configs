{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkIf mkEnableOption mkOption optionals types;

  cfg = config.nvidia;
in {
  options.nvidia = {
    enable = mkEnableOption (mdDoc "nvidia");

    enableNvidiaSettings = mkOption {
      type = types.bool;
      default = false;
    };

    enableWayland = mkOption {
      type = types.bool;
      default = false;
    };

    enableCUDA = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        nvidia-vaapi-driver
      ];
      extraPackages32 = with pkgs; [vaapiVdpau];
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = cfg.enableNvidiaSettings;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement = {
        enable = false;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        finegrained = false;
      };

      open = cfg.enableWayland;

      package =
        if !cfg.enableWayland
        then config.boot.kernelPackages.nvidiaPackages.stable
        else let
          rcu_patch = pkgs.fetchpatch {
            url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
            hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
          };
        in
          # Keep the driver version at 535.xx.xx for Wayland desktop
          # games stutter on more recent versions
          # https://github.com/NixOS/nixpkgs/blob/e256f39bec8e01808c0a3e411d961cbced3f4e09/pkgs/os-specific/linux/nvidia-x11/default.nix#L70
          config.boot.kernelPackages.nvidiaPackages.mkDriver rec {
            version = "535.43.28";
            persistencedVersion = "535.98";
            settingsVersion = "535.98";
            sha256_64bit = "sha256-ic7r3MPp65fdEwqDRyc0WiKonL5eF6KZUpfD/C3vYaU=";
            openSha256 = "sha256-a5iccyISHheOfTwpsrz6puqrVhgzYWFvNlykVG3+PVc=";
            settingsSha256 = "sha256-jCRfeB1w6/dA27gaz6t5/Qo7On0zbAPIi74LYLel34s=";
            persistencedSha256 = "sha256-WviDU6B50YG8dO64CGvU3xK8WFUX8nvvVYm/fuGyroM=";
            url = "https://developer.nvidia.com/downloads/vulkan-beta-${lib.concatStrings (lib.splitVersion version)}-linux";

            patches = [rcu_patch];
          };
    };

    environment.systemPackages =
      optionals cfg.enableCUDA [pkgs.cudaPackages.cudatoolkit]
      ++ (with pkgs; [
        libva-utils
        nvidia-vaapi-driver
        nvtopPackages.nvidia
        pciutils
        vdpauinfo
      ]);

    boot.kernelModules = optionals cfg.enableCUDA ["nvidia-uvm"];
  };
}
