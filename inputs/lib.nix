let
  inherit (builtins) fetchTarball fromJSON readFile removeAttrs;

  lock = fromJSON (readFile ../flake.lock);
  lib = import "${fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${lock.nodes.nixpkgs.locked.rev}.tar.gz";
    sha256 = lock.nodes.nixpkgs.locked.narHash;
  }}/lib";

  inherit (lib) attrValues findFirst foldl' hasAttr matchAttrs optionalAttrs recursiveUpdate;

  recursiveUpdateList = list: foldl' recursiveUpdate {} list;
in rec {
  /*
  * From an attrset, returns a flake input that has its type defaulted
  * to `github` and has some of its inputs following this flake's input
  * of the same name.
  *
  * It gets information from the `flake.lock` file and can be used thanks
  * to flakegen
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
      (mkOverride "flake-parts")
      (mkOverride "treefmt-nix")
      (mkOverride "lib-aggregate")
      (mkOverride "nix-eval-jobs")
    ];

  mkDep = info: mkInput (recursiveUpdate info {inputs.nixpkgs.follows = "nixpkgs";});

  mkHyprDep = info: mkInput (recursiveUpdate info {inputs.hyprland.follows = "hyprland";});

  mkSrc = info: mkInput (info // {flake = false;});
}
