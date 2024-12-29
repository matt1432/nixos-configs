{...}: let
  inherit (builtins) hasAttr isAttrs tryEval;
  inputsLib = import ../../inputs/lib.nix;
in {
  inherit (inputsLib) recursiveUpdateList;

  throws = x: !(tryEval x).success;
  hasVersion = x: isAttrs x && hasAttr "version" x;
}
