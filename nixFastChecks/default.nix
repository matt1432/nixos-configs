# Inspired by :
# https://github.com/Mic92/dotfiles/blob/c2f538934d67417941f83d8bb65b8263c43d32ca/flake.nix#L168
{
  perSystem,
  self,
  ...
}: let
  inherit (self.lib.attrs) recursiveUpdateList;

  apps = perSystem (import ./apps);
  devices = perSystem (pkgs: import ./devices {inherit pkgs self;});
  devShells = perSystem (pkgs: import ./devShells {inherit pkgs self;});
  packages = perSystem (import ./packages);
in {
  inherit apps devices devShells packages;

  all = recursiveUpdateList [apps devices devShells packages];
}
