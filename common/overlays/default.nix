{nixpkgs-wayland, ...} @ inputs: [
  (import ./dracula-theme inputs)

  nixpkgs-wayland.overlay
]
