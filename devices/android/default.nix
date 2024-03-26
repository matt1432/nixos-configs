{
  home-manager,
  nixpkgs,
  ...
} @ inputs: rec {
  extraSpecialArgs = inputs;
  home-manager-path = home-manager.outPath;
  pkgs = import nixpkgs {
    system = "aarch64-linux";
    overlays = import ../../common/overlays inputs;
  };

  modules = [
    {
      options = with pkgs.lib; {
        environment.variables.FLAKE = mkOption {
          type = with types; nullOr str;
        };
      };
    }
    {home-manager.extraSpecialArgs = inputs;}
    ../../common/nix-on-droid.nix
    ./nix-on-droid.nix
  ];
}
