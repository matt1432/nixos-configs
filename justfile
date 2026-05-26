default:
  @just --list

docs:
  nix run --no-lazy-trees "$FLAKE"#gen-docs

genflake:
  #!/usr/bin/env bash
  # Get changes from inputs/default.nix
  nix run --no-lazy-trees "$FLAKE"#genflake "$FLAKE"/flake.nix &&
  # Evaluate `follows` from new flake.lock
  nix run --no-lazy-trees "$FLAKE"#genflake "$FLAKE"/flake.nix &&
  # Make sure everything is right
  nix run --no-lazy-trees "$FLAKE"#genflake "$FLAKE"/flake.nix

  alejandra -q "$FLAKE"/flake.nix

[positional-arguments]
l2s action list='':
  nix run --no-lazy-trees "$FLAKE"#list2series -- "$@"

[positional-arguments]
mc-mods version action='check':
  nix run --no-lazy-trees "$FLAKE"#mc-mods -- "$@"

[positional-arguments]
pin args:
  nix run --no-lazy-trees "$FLAKE"#pin-inputs -- "$@"

[positional-arguments]
up args:
  nix run --no-lazy-trees "$FLAKE"#update-sources -- "$@"
