{nixpkgs-wayland, ...} @ inputs: [
  (import ./dracula-theme inputs)
  (import ./squeekboard)

  nixpkgs-wayland.overlay
]
