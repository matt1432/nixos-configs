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

      # FIXME: https://github.com/NixOS/nixpkgs/pull/495704
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "590.48.01";
        sha256_64bit = "sha256-ueL4BpN4FDHMh/TNKRCeEz3Oy1ClDWto1LO/LWlr1ok=";
        sha256_aarch64 = "sha256-FOz7f6pW1NGM2f74kbP6LbNijxKj5ZtZ08bm0aC+/YA=";
        openSha256 = "sha256-hECHfguzwduEfPo5pCDjWE/MjtRDhINVr4b1awFdP44=";
        settingsSha256 = "sha256-NWsqUciPa4f1ZX6f0By3yScz3pqKJV1ei9GvOF8qIEE=";
        persistencedSha256 = "sha256-wsNeuw7IaY6Qc/i/AzT/4N82lPjkwfrhxidKWUtcwW8=";
        patchesOpen = [
          (pkgs.fetchpatch {
            url = "https://github.com/CachyOS/CachyOS-PKGBUILDS/raw/d5629d64ac1f9e298c503e407225b528760ffd37/nvidia/nvidia-utils/kernel-6.19.patch";
            hash = "sha256-YuJjSUXE6jYSuZySYGnWSNG5sfVei7vvxDcHx3K+IN4=";
          })
        ];
      };

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
