{
  inputs,
  mkVersion,
  pkgs,
  ...
}: let
  inherit (pkgs) lib;

  mkScope = file:
    lib.recurseIntoAttrs
    (pkgs.callPackage file ({inherit mkVersion;} // inputs));
in {
  dracula = mkScope ./dracula;
  hass-addons = mkScope ./hass-addons;
  firefoxAddons = mkScope ./firefox-addons;
  mpvScripts = mkScope ./mpv-scripts;
}
