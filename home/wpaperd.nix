{
  pkgs,
  wpaperd,
  ...
}: let
  inherit (pkgs.writers) writeTOML;
  wpaperdPkg = wpaperd.packages.${pkgs.system}.default;
  wallpaper = "${pkgs.dracula-theme}/wallpapers/waves.png";
in {
  home.packages = [wpaperdPkg];

  xdg.configFile."wpaperd/config.toml".source = writeTOML "config.toml" {
    default = {
      path = wallpaper;
    };
  };
}
