{ neovim-nightly-overlay, ... }:

{
  nixpkgs.overlays = [
    (import ./swayosd.nix)
    (import ./blueberry.nix)
    (import ./dracula-theme.nix)

    (final: prev: {
      input-emulator = final.callPackage ./pkgs/input-emulator.nix {};
    })

    (final: prev: {
      pam-fprint-grosshack = final.callPackage ./pkgs/pam-fprint-grosshack.nix {};
    })

    (final: prev: {
      coloryou = final.callPackage ./pkgs/coloryou/default.nix {};
    })

    neovim-nightly-overlay.overlay
  ];
}
