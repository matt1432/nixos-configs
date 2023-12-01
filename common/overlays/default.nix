{
  neovim-flake,
  nixpkgs-wayland,
  ...
}: {
  imports = [
    ./dracula-theme
    ./regreet
  ];

  nixpkgs.overlays = [
    (import ./blueberry)
    (import ./squeekboard)

    neovim-flake.overlay
    nixpkgs-wayland.overlay
  ];
}
