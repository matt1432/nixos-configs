{
  hycov,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    plugins = [hycov.packages.${pkgs.system}.hycov];

    settings = {
      plugin = {
        hycov = {
          enable_alt_release_exit = 1;
          overview_gappo = 60; #gaps width from screen
          overview_gappi = 24; #gaps width from clients
          enable_hotarea = 0;
        };
      };

      bind = [
        "ALT, tab,    hycov:toggleoverview"
        "ALT, left,   hycov:movefocus, l"
        "ALT, right,  hycov:movefocus, r"
        "ALT, up,     hycov:movefocus, u"
        "ALT, down,   hycov:movefocus, d"
      ];
    };
  };
}
