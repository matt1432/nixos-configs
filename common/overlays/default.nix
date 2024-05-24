{
  grim-hyprland,
  nixpkgs-wayland,
  ...
} @ inputs: [
  (import ./dracula-theme inputs)

  grim-hyprland.overlays.default
  nixpkgs-wayland.overlay
]
