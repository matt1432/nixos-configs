{ neovim-flake, ... }: {
  imports = [
    ./dracula-theme.nix
    ./regreet.nix
  ];

  nixpkgs.overlays = [
    (import ./blueberry.nix)
    (import ./squeekboard.nix)
    neovim-flake.overlay

    (final: prev: {
      spotifywm = final.callPackage ./pkgs/spotifywm.nix {};
    })

    (final: prev: {
      input-emulator = final.callPackage ./pkgs/input-emulator.nix {};
    })

    (final: prev: {
      pam-fprint-grosshack = final.callPackage ./pkgs/pam-fprint-grosshack.nix {};
    })

    (final: prev: {
      coloryou = final.callPackage ./pkgs/coloryou/default.nix {};
    })
  ];
}
