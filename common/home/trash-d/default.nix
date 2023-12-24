{pkgs, ...}: let
  trash = pkgs.callPackage ./trash-d.nix pkgs;
in {
  home.packages = [trash];

  programs.bash.shellAliases.rm = "trash";
}
