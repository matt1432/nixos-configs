let
  inherit (builtins) fromJSON readFile;

  lock = fromJSON (readFile ../flake.lock);
  lib = import "${fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${lock.nodes.nixpkgs.locked.rev}.tar.gz";
    sha256 = lock.nodes.nixpkgs.locked.narHash;
  }}/lib";

  inherit (lib) attrNames attrValues findFirst foldl' hasAttr matchAttrs optionalAttrs optionals recursiveUpdate;
in rec {
  recursiveUpdateList = list: foldl' recursiveUpdate {} list;

  findInput = info:
    findFirst
    (x: matchAttrs (removeAttrs info ["inputs"]) (x.original or {})) {}
    (attrValues lock.nodes);

  mkFollowsFrom = info: target: follows:
    optionalAttrs
    (hasAttr target ((findInput info).inputs or {}))
    {inputs.${target} = {inherit follows;};};

  /*
  * From an attrset, returns a flake input that has its type defaulted
  * to `github` and has some of its inputs following this flake's input
  * of the same name.
  *
  * It gets information from the `flake.lock` file and can be used thanks
  * to flakegen
  */
  mkInput = {
    type ? "github",
    overrideNixpkgs ? true,
    ...
  } @ info: let
    mkOverride = i: mkFollowsFrom info i i;
  in
    recursiveUpdateList ([
        (removeAttrs info ["overrideNixpkgs"])
        {inherit type;}

        # Generic inputs
        (mkOverride "flake-compat")
        (mkOverride "flake-parts")

        (mkOverride "flake-utils")
        (mkFollowsFrom info "utils" "flake-utils")

        (mkOverride "git-hooks")
        (mkOverride "lib-aggregate")
        (mkOverride "nix-eval-jobs")
        (mkOverride "nixpkgs-docs")
        (mkOverride "nixpkgs-lib")
        (mkOverride "nix-github-actions")
        (mkOverride "pre-commit-hooks")
        (mkOverride "systems")
        (mkOverride "treefmt-nix")
      ]
      # Specify if we can't make an input use this flake's nixpkgs
      ++ optionals overrideNixpkgs [(mkOverride "nixpkgs")]);

  mkHyprDep = info: let
    inherit (lock.nodes) hyprland;

    mkOverride = i: mkFollowsFrom info i i;
    mkHyprOverride = i: mkFollowsFrom info i "hyprland/${i}";
  in
    mkInput (recursiveUpdateList ([info (mkOverride "hyprland")]
        ++ (map mkHyprOverride (attrNames hyprland.inputs))));

  mkSrc = info: mkInput (info // {flake = false;});
}
