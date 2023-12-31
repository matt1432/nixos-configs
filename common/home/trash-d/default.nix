{pkgs, ...} @ inputs: let
  trash = pkgs.callPackage ./trash-d.nix inputs;
in {
  home.packages = [trash];

  programs.bash.shellAliases.rm = "trash";
}
