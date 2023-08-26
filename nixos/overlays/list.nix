{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ./swayosd.nix)
    (import ./blueberry.nix)

    (final: prev: {
      input-emulator = final.callPackage ./pkgs/input-emulator.nix {};
    })

    (final: prev: {
      pam-fprint-grosshack = final.callPackage ./pkgs/pam-fprint-grosshack.nix {};
    })

    (final: prev: {
      dracula-plymouth = final.callPackage ./pkgs/dracula-plymouth.nix {};
    })

    (final: prev: {
      lavanda-sddm = final.callPackage ./pkgs/lavanda-sddm.nix {};
    })

    (final: prev: {
      coloryou = final.callPackage ./pkgs/coloryou/default.nix {};
    })

    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
    }))
  ];
}
