{
  pkgs,
  self,
  wpaperd,
  ...
}: let
  inherit (pkgs.writers) writeTOML;
  wpaperdPkg = wpaperd.packages.${pkgs.system}.default;
in {
  home.packages = [wpaperdPkg];

  xdg.configFile."wpaperd/config.toml".source = writeTOML "config.toml" {
    default = {
      path = toString self.legacyPackages.${pkgs.system}.dracula.wallpaper;
      mode = "stretch";
    };
  };
}
