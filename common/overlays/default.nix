{nixpkgs-wayland, ...} @ inputs: [
  (import ./dracula-theme inputs)
  (import ./plymouth inputs)
  (import ./spotifywm inputs)
  (import ./squeekboard)

  nixpkgs-wayland.overlay
]
