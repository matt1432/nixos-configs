{nixpkgs-wayland, ...} @ inputs: [
  (import ./dracula-theme inputs)
  (import ./spotifywm inputs)
  (import ./squeekboard)

  nixpkgs-wayland.overlay
]
