{
  Hyprspace,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    plugins = [Hyprspace.packages.${pkgs.system}.Hyprspace];

    settings = {
      bind = [
        "ALT, tab, overview:toggle"
      ];
    };
  };
}
