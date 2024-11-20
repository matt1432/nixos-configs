{
  perSystem,
  inputs,
}: let
  inherit (inputs.nixpkgs.lib) concatStringsSep stringToCharacters substring tail toUpper;

  mkVersion = src: "0.0.0+" + src.shortRev;
  capitalise = str: (toUpper (substring 0 1 str) + (concatStringsSep "" (tail (stringToCharacters str))));
in
  {inherit mkVersion capitalise;}
  // (import ./flake-lib.nix inputs)
  // perSystem (pkgs:
    import ./pkgs.nix {inherit pkgs mkVersion capitalise inputs;})
