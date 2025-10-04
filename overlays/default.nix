{
  self ? {},
  description ? false,
}: let
  inputs = self.inputs // {inherit self;};

  overlay = mod: desc:
    if description
    then desc
    else mod;
in {
  appsPackages =
    overlay
    (import ../apps/packages.nix {
      inherit inputs;
    })
    ''
      This overlay puts every derivations for apps exposed by this flake
      under pkgs.appsPackages.
    '';

  misc-fixes =
    overlay
    (import ./misc-fixes)
    ''
      Fixes build failures, missing meta attributes, evaluation failures, etc.
      of the current `nixpkgs` revision of this flake.
    '';

  forced =
    overlay
    (import ./forced self)
    ''
      Overrides packages from third party flakes that don't offer overlays.
    '';

  nix-version =
    overlay
    (import ./nix-version self)
    ''
      Overrides the nix package for everything so I don't need multiple versions.
    '';

  scopedPackages =
    overlay
    (import ../scopedPackages {
      inherit (self.lib) mkVersion;
      inherit inputs;
    })
    ''
      This overlay puts every package scopes exposed by this flake
      under pkgs.scopedPackages.
    '';

  selfPackages =
    overlay
    (import ../packages {
      inherit (self.lib) mkVersion;
      inherit inputs;
    })
    ''
      This overlay puts every derivations for packages exposed by this flake
      under pkgs.selfPackages.
    '';
}
