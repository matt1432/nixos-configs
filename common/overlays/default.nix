{nixpkgs-wayland, ...} @ inputs: [
  (import ./dracula-theme inputs)
  (import ./fprintd)
  (import ./squeekboard)

  nixpkgs-wayland.overlay
]
