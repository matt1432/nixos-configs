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
  firefoxAddons = mkScope ./firefox-addons;
  hass-components = mkScope ./hass-components;
  lovelace-components = mkScope ./lovelace-components;
  mpvScripts = mkScope ./mpv-scripts;
}
