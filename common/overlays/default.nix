{
  neovim-flake,
  nixpkgs-wayland,
  ...
} @ inputs: [
  (import ./dracula-theme inputs)
  (import ./plymouth inputs)
  (import ./spotifywm inputs)
  (import ./squeekboard)

  neovim-flake.overlay
  nixpkgs-wayland.overlay
]
