{
  Hyprspace,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    plugins = [
      (Hyprspace.packages.${pkgs.system}.Hyprspace.overrideAttrs {
        dontUseCmakeConfigure = true;
      })
    ];

    settings = {
      bind = [
        "ALT, tab, overview:toggle"
      ];
    };
  };
}
