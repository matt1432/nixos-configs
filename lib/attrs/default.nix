{...}: let
  inputsLib = import ../../inputs/lib.nix;
in {
  inherit (inputsLib) recursiveUpdateList;
}
