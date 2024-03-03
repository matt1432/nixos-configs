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

      package = with config.boot.kernelPackages.nvidiaPackages;
        if cfg.enableWayland
        # Vulkan is much more stable in Wayland
        then vulkan_beta
        else stable;
    };

    environment.systemPackages = with pkgs; ([
        libva-utils
        nvidia-vaapi-driver
        nvtop-nvidia
        pciutils
        vdpauinfo
      ]
      ++ optionals cfg.enableCUDA [cudaPackages.cudatoolkit]);

    boot.kernelModules = optionals cfg.enableCUDA ["nvidia-uvm"];
  };
}
