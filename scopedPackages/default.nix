{
  inputs ? {},
  mkVersion ? {},
  description ? false,
}: (final: prev: let
  inherit (final.lib) recurseIntoAttrs;

  mkScope = file: desc:
    if description
    then desc
    else
      recurseIntoAttrs
      (final.callPackage file ({inherit mkVersion;} // inputs));
in {
  scopedPackages = {
    dracula = mkScope ./dracula ''
      Custom derivations that each represent an app's Dracula Theme.
    '';

    firefoxAddons = mkScope ./firefox-addons ''
      Every extensions I use in my firefox module.
    '';

    hass-components = mkScope ./hass-components ''
      Components I use for Home-Assistant that aren't in nixpkgs.
    '';

    lovelace-components = mkScope ./lovelace-components ''
      Lovelace components I use for Home-Assistant that aren't in nixpkgs.
    '';

    mpvScripts = mkScope ./mpv-scripts ''
      MPV scripts I use that aren't in nixpkgs.
    '';
  };
})
