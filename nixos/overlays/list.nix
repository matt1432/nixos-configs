{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ./swayosd.nix)
    (import ./blueberry.nix)
    (import ./tutanota-desktop.nix)

    (final: prev: {
      pam-fprint-grosshack = final.callPackage ./pkgs/pam-fprint-grosshack.nix {};
    })

    (final: prev: {
      dracula-plymouth = final.callPackage ./pkgs/dracula-plymouth.nix {};
    })

    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
    }))
  ];
}
