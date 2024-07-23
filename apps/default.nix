{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) getExe;

  mkApp = file: {
    program = getExe (pkgs.callPackage file ({} // inputs));
    type = "app";
  };
in {
  updateFlake = mkApp ./update;
}
