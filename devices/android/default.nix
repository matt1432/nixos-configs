{
  home-manager,
  neovim-flake,
  nix-on-droid,
  nixpkgs,
  ...
} @ inputs: {
  extraSpecialArgs = inputs;
  home-manager-path = home-manager.outPath;
  pkgs = import nixpkgs {
    system = "aarch64-linux";
    overlays = [
      nix-on-droid.overlays.default
      neovim-flake.overlay
      (import ../../common/overlays/dracula-theme inputs)
    ];
  };

  modules = [
    {home-manager.extraSpecialArgs = inputs;}
    ../../common/nix-on-droid.nix
    ./nix-on-droid.nix
  ];
}
