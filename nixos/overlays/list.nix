{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ./swayosd.nix)
    (import ./blueberry.nix)

    (final: prev: {
      tutanota = final.callPackage ./pkgs/tutanota.nix {};
    })

    (final: prev: {
      pam-fprint-grosshack = final.callPackage ./pkgs/pam-fprint-grosshack.nix {};
    })

    (final: prev: {
      dracula-plymouth = final.callPackage ./pkgs/dracula-plymouth.nix {};
    })
  ];
}
