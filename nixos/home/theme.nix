{ pkgs, ... }:

{
  xdg.configFile = {
    "../.themes/Dracula".source   = "${pkgs.dracula-theme}/share/themes/Dracula";

    "Kvantum/Dracula".source              = "${pkgs.dracula-theme}/share/Kvantum/Dracula";
    "Kvantum/Dracula-Solid".source        = "${pkgs.dracula-theme}/share/Kvantum/Dracula-Solid";
    "Kvantum/Dracula-purple".source       = "${pkgs.dracula-theme}/share/Kvantum/Dracula-purple";
    "Kvantum/Dracula-purple-solid".source = "${pkgs.dracula-theme}/share/Kvantum/Dracula-purple-solid";
  };
}
