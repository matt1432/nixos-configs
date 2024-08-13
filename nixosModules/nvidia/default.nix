{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption optionals types;

  cfg = config.nvidia;
in {
  options.nvidia = {
    enable = mkEnableOption "nvidia";

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
    hardware.graphics = {
      enable = true;
      enable32Bit = true;

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

      open = false;

      package = let
        inherit (config.boot.kernelPackages.nvidiaPackages) stable latest;
      in
        if !cfg.enableWayland
        then stable
        else
          # Stick to 555 driver version for better Wayland support
          latest;
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

    boot.kernelModules =
      optionals cfg.enableCUDA ["nvidia-uvm"]
      ++ ["nvidia" "nvidia-drm"];
  };

  # For accurate stack trace
  _file = ./default.nix;
}
