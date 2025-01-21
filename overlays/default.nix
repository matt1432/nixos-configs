{
  self ? {},
  description ? false,
}: let
  overlay = mod: desc:
    if description
    then desc
    else mod;
in {
  misc-fixes =
    overlay
    (import ./misc-fixes)
    ''
      Fixes build failures, missing meta attributes, evaluation failures, etc.
      of the current `nixpkgs` revision of this flake.
    '';

  nix-version =
    overlay
    (import ./nix-version self)
    ''
      Overrides the nix package for everything so I don't need multiple versions.
    '';

  xdg-desktop-portal-kde =
    overlay
    (import ./xdg-desktop-portal-kde)
    ''
      Fixes this issue: https://invent.kde.org/plasma/xdg-desktop-portal-kde/-/issues/15
    '';
}
