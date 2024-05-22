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
        else
          # Get newest beta driver version for better Wayland support
          config.boot.kernelPackages.nvidiaPackages.mkDriver {
            version = "555.42.02";
            sha256_64bit = "sha256-k7cI3ZDlKp4mT46jMkLaIrc2YUx1lh1wj/J4SVSHWyk=";
            sha256_aarch64 = "sha256-ekx0s0LRxxTBoqOzpcBhEKIj/JnuRCSSHjtwng9qAc0=";
            openSha256 = "sha256-3/eI1VsBzuZ3Y6RZmt3Q5HrzI2saPTqUNs6zPh5zy6w=";
            settingsSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
            persistencedSha256 = "sha256-3ae31/egyMKpqtGEqgtikWcwMwfcqMv2K4MVFa70Bqs=";
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
