{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.boot.plymouth;
in {
  config.boot = mkIf cfg.enable {
    initrd = {
      verbose = false;
      systemd.enable = true;
    };

    consoleLogLevel = 0;

    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "i915.fastboot=1"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    loader.timeout = 0;
  };

  # For accurate stack trace
  _file = ./default.nix;
}
