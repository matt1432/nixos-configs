{ pkgs, ... }: {
  services = {

    fwupd.enable = true;
    upower.enable = true;

    locate = {
      enable = true;
      package = pkgs.mlocate;
      localuser = null;
      interval = "hourly";
      prunePaths = [
        "/tmp"
        "/var/tmp"
        "/var/cache"
        "/var/lock"
        "/var/run"
        "/var/spool"
        "/nix/var/log/nix"
        "/proc"
        "/run/user"
      ];
    };
  };
}
