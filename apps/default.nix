{
  inputs,
  pkgs,
  ...
}: let
  mkApp = file: {
    program = pkgs.callPackage file ({} // inputs);
    type = "app";
  };
in {
  updateFlake = mkApp ./update;
}
