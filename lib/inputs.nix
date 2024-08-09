lib: lock: let
  inherit (lib) attrValues findFirst foldl' hasAttr matchAttrs optionalAttrs recursiveUpdate removeAttrs;

  recursiveUpdateList = list: foldl' recursiveUpdate {} list;
in rec {
  /*
  *
  From an attrset, returns a flake input that has its type defaulted
  to `github` and has some of its inputs following this flake's input
  of the same name.

  It gets information from the `flake.lock` file and can be used thanks
  to flakegen
  */
  mkInput = {type ? "github", ...} @ info: let
    input =
      findFirst
      (x: matchAttrs (removeAttrs info ["inputs"]) (x.original or {})) {}
      (attrValues lock.nodes);

    mkOverride = i:
      optionalAttrs
      (hasAttr i (input.inputs or {}))
      {inputs.${i}.follows = i;};
  in
    recursiveUpdateList [
      info
      {inherit type;}
      (mkOverride "systems")
      (mkOverride "flake-utils")
      (mkOverride "lib-aggregate")
    ];

  mkDep = info: mkInput (recursiveUpdate info {inputs.nixpkgs.follows = "nixpkgs";});

  mkHyprDep = info: mkInput (recursiveUpdate info {inputs.hyprland.follows = "hyprland";});

  mkSrc = info: mkInput (info // {flake = false;});
}
