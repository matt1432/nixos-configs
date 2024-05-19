{
  grim-hyprland,
  neovim-nightly,
  nixpkgs-wayland,
  ...
} @ inputs: [
  (import ./dracula-theme inputs)

  grim-hyprland.overlays.default
  neovim-nightly.overlay
  nixpkgs-wayland.overlay
]
