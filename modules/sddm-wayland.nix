{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    dracula-theme
  ];

  services = {
    xserver = {
      enable = true;
      layout = "ca";
      displayManager = {
        sddm = {
          enable = true;
          settings = {
            General = {
              DisplayServer = "wayland";
              InputMethod = "";
            };
            Wayland.CompositorCommand = "${pkgs.weston}/bin/weston --shell=fullscreen-shell.so";
            Theme = {
              Current = "Dracula";
              CursorTheme = "Dracula-cursors";
              CursorSize = 24;
            };
          };
        };
      };
    };
    gnome.gnome-keyring.enable = true;
  };
}
