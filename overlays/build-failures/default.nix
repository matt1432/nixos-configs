final: prev: let
  pkgs = final;

  inherit (pkgs) callPackages recurseIntoAttrs;
in {
  # FIXME: https://pr-tracker.nelim.org/?pr=373146
  bat-extras = recurseIntoAttrs (callPackages ./bat-extras.nix {});

  # FIXME: https://pr-tracker.nelim.org/?pr=357699
  nodejs_latest = prev.nodejs_22;
}
