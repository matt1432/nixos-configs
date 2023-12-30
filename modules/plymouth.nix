{pkgs, ...}: {
  boot = {
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

    plymouth = {
      enable = true;
      themePackages = [pkgs.dracula-theme];
      theme = "dracula";
    };
  };
}
