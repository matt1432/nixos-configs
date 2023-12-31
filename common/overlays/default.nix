{
  neovim-flake,
  nixpkgs-wayland,
  ...
} @ inputs: {
  nixpkgs.overlays = [
    (import ./dracula-theme inputs)
    (import ./plymouth inputs)
    (import ./spotifywm inputs)
    (import ./squeekboard)

    neovim-flake.overlay
    nixpkgs-wayland.overlay
  ];
}
