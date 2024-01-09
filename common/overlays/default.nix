{
  neovim-flake,
  nixpkgs-wayland,
  nixd,
  ...
} @ inputs: {
  nixpkgs.overlays = [
    (import ./dracula-theme inputs)
    (import ./plymouth inputs)
    (import ./spotifywm inputs)
    (import ./squeekboard)

    neovim-flake.overlay
    nixpkgs-wayland.overlay
    nixd.overlays.default
  ];
}
