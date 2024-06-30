{config, ...}: let
  inherit (config.vars) mainUser;
in {
  # Auto-login to plasma
  services = {
    desktopManager.plasma6.enable = true;

    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        autoLogin.relogin = true;
      };

      autoLogin = {
        enable = true;
        user = mainUser;
      };

      defaultSession = "plasma";
    };
  };

  programs = {
    xwayland.enable = true;
    kdeconnect.enable = true;
  };

  # Enable flatpak support
  services.flatpak.enable = true;
  services.packagekit.enable = true;

  jovian.steam = {
    enable = true;
    user = mainUser;

    desktopSession = config.services.displayManager.defaultSession;
  };

  jovian.decky-loader = {
    enable = true;
    user = mainUser;
  };
}
