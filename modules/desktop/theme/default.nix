self: {...}: {
  imports = [
    ./gtk
    ./xresources.nix

    (import ./cursors.nix self)
    (import ./qt.nix self)
    (import ./hyprpaper.nix self)
  ];

  config.wayland.windowManager.hyprland = {
    settings = {
      windowrule = [
        "size 1231 950,title:^(Open Folder)$"
        "float,title:^(Open Folder)$"

        "size 1231 950,title:^(Open File)$"
        "float,title:^(Open File)$"
      ];

      layerrule = [
        "noanim, selection"
      ];
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
