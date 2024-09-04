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
  hass-components = mkScope ./hass-components;
  firefoxAddons = mkScope ./firefox-addons;
  mpvScripts = mkScope ./mpv-scripts;
}
