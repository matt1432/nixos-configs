default:
  @just --list

docs args:
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
pin args:
  nix run "$FLAKE"#pin-inputs -- "$@"

[positional-arguments]
update args:
  nix run "$FLAKE"#update-sources -- "$@"
