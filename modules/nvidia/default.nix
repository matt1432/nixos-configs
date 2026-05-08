{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkIf mkEnableOption mkOption optionals types;

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

      extraPackages = attrValues {
        inherit
          (pkgs)
          libva-vdpau-driver
          libvdpau-va-gl
          nvidia-vaapi-driver
          vulkan-loader
          vulkan-validation-layers
          vulkan-extension-layer
          ;
      };
      extraPackages32 = attrValues {
        inherit
          (pkgs)
          libva-vdpau-driver
          vulkan-loader
          vulkan-validation-layers
          vulkan-extension-layer
          ;
      };
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      open = true;

      package = config.boot.kernelPackages.nvidiaPackages.beta;

      # Whether to enable nvidia-settings, NVIDIA's GUI configuration tool
      nvidiaSettings = cfg.enableNvidiaSettings;
    };

    environment.systemPackages =
      optionals cfg.enableCUDA [pkgs.cudaPackages.cudatoolkit]
      ++ (attrValues {
        inherit (pkgs.nvtopPackages) nvidia;
        inherit
          (pkgs)
          libva-utils
          nvidia-vaapi-driver
          pciutils
          vdpauinfo
          vulkan-tools
          ;
      });

    boot.kernelModules =
      optionals cfg.enableCUDA ["nvidia-uvm"]
      ++ ["nvidia" "nvidia-drm"];
  };

  # For accurate stack trace
  _file = ./default.nix;
}
