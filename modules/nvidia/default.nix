{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) toJSON;
  inherit (lib) attrValues mkIf mkEnableOption mkOption optionals optionalString types;

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

      package = config.boot.kernelPackages.nvidiaPackages.latest;

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

    # Fixes egl-wayland issues with beta drivers
    # https://github.com/hyprwm/Hyprland/issues/7202
    environment.etc = let
      mkEglFile = n: library: let
        suffix = optionalString (library != "wayland") ".1";
        pkg =
          if library != "wayland"
          then config.hardware.nvidia.package
          else pkgs.egl-wayland;

        fileName = "${toString n}_nvidia_${library}.json";
        library_path = "${pkg}/lib/libnvidia-egl-${library}.so${suffix}";
      in {
        "egl/egl_external_platform.d/${fileName}".source = pkgs.writeText fileName (toJSON {
          file_format_version = "1.0.0";
          ICD = {inherit library_path;};
        });
      };
    in
      mkIf cfg.enableWayland (
        {"egl/egl_external_platform.d".enable = false;}
        // mkEglFile 10 "wayland"
        // mkEglFile 15 "gbm"
        // mkEglFile 20 "xcb"
        // mkEglFile 20 "xlib"
      );
  };

  # For accurate stack trace
  _file = ./default.nix;
}
