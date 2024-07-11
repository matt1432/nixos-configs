{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) hasAttr mkIf optionals;

  cfg = config.boot.plymouth;
in {
  boot = mkIf cfg.enable {
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

    plymouth.themePackages =
      [
        self.legacyPackages.${pkgs.system}.dracula.plymouth
      ]
      ++ optionals (hasAttr "steamdeck-hw-theme" pkgs) [
        pkgs.steamdeck-hw-theme
      ];
  };
}
