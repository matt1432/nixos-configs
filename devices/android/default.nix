{
  home-manager,
  nixpkgs,
  ...
} @ inputs: {
  extraSpecialArgs = inputs;
  home-manager-path = home-manager.outPath;
  pkgs = import nixpkgs {
    system = "aarch64-linux";
    overlays = import ../../common/overlays inputs;
  };

  modules = [
    {home-manager.extraSpecialArgs = inputs;}
    ../../common/nix-on-droid.nix
    ./nix-on-droid.nix
  ];
}
