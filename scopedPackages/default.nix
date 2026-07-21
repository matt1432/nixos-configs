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

    mpvScripts = mkScope ./mpv-scripts ''
      MPV scripts I use that aren't in nixpkgs.
    '';

    protonGE = mkScope ./proton-ge ''
      My pinned versions of proton-ge-bin.
    '';
  };
})
