# Inspired by :
# https://github.com/Mic92/dotfiles/blob/c2f538934d67417941f83d8bb65b8263c43d32ca/flake.nix#L168
{
  perSystem,
  self,
  ...
}: let
  inherit (self.lib.attrs) recursiveUpdateList;

  aptDevices = perSystem (pkgs:
    import ./devices {
      onlyApt = true;
      inherit pkgs self;
    });

  apps = perSystem (pkgs: import ./apps {inherit pkgs self;});
  devices = perSystem (pkgs: import ./devices {inherit pkgs self;});
  devShells = perSystem (pkgs: import ./devShells {inherit pkgs self;});
  packages = perSystem (pkgs: import ./packages {inherit pkgs self;});
in {
  # Allow homie to serve a binary cache for the devices away from servivi
  aptDevices = recursiveUpdateList [aptDevices devShells];

  all = recursiveUpdateList [apps devices devShells packages];
  inherit apps devices devShells packages;
}
