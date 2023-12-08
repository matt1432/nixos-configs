{
  neovim-flake,
  nixpkgs-wayland,
  ...
}: {
  nixpkgs.overlays = [
    (import ./dracula-theme)
    (import ./spotifywm)
    (import ./squeekboard)

    neovim-flake.overlay
    nixpkgs-wayland.overlay
  ];
}
