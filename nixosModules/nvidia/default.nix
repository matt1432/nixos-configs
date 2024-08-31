{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) toJSON;
  inherit (lib) mkIf mkEnableOption mkOption optionals optionalString types;

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

      extraPackages = builtins.attrValues {
        inherit
          (pkgs)
          vaapiVdpau
          libvdpau-va-gl
          nvidia-vaapi-driver
          ;
      };
      extraPackages32 = [pkgs.vaapiVdpau];
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
        inherit (config.boot.kernelPackages.nvidiaPackages) latest stable;
      in
        if !cfg.enableWayland
        then stable
        else latest;
    };

    environment.systemPackages =
      optionals cfg.enableCUDA [pkgs.cudaPackages.cudatoolkit]
      ++ (builtins.attrValues {
        inherit (pkgs.nvtopPackages) nvidia;
        inherit
          (pkgs)
          libva-utils
          nvidia-vaapi-driver
          pciutils
          vdpauinfo
          ;
      });

    boot.kernelModules =
      optionals cfg.enableCUDA ["nvidia-uvm"]
      ++ ["nvidia" "nvidia-drm"];

    # Fixes egl-wayland issues with beta drivers
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
