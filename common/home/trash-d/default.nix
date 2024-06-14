{
  pkgs,
  self,
  ...
}: {
  home.packages = [self.packages.${pkgs.system}.trash-d];

  programs.bash.shellAliases.rm = "trash";
}
