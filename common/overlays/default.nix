{
  neovim-flake,
  nixpkgs-wayland,
  ...
}: {
  nixpkgs.overlays = [
    (import ./dracula-theme)
    (import ./plymouth)
    (import ./spotifywm)
    (import ./squeekboard)

    neovim-flake.overlay
    nixpkgs-wayland.overlay
  ];
}
