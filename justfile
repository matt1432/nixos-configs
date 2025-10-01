default:
  @just --list

docs:
  nix run "$FLAKE"#gen-docs

genflake:
  #!/usr/bin/env bash
  # Get changes from inputs/default.nix
  nix run "$FLAKE"#genflake "$FLAKE"/flake.nix &&
  # Evaluate `follows` from new flake.lock
  nix run "$FLAKE"#genflake "$FLAKE"/flake.nix &&
  # Make sure everything is right
  nix run "$FLAKE"#genflake "$FLAKE"/flake.nix

  alejandra -q "$FLAKE"/flake.nix

[positional-arguments]
l2s action list='':
  nix run "$FLAKE"#list2series -- "$@"

[positional-arguments]
mc-mods version action='check':
  nix run "$FLAKE"#mc-mods -- "$@"

[positional-arguments]
pin args:
  nix run "$FLAKE"#pin-inputs -- "$@"

[positional-arguments]
up args:
  nix run "$FLAKE"#update-sources -- "$@"
