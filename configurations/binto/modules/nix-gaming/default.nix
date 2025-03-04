{
  nix-gaming,
  pkgs,
  ...
}: {
  imports = [
    nix-gaming.nixosModules.platformOptimizations
  ];

  programs = {
    steam = {
      enable = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;

      extraCompatPackages = [
        pkgs.selfPackages.proton-ge-latest
      ];

      platformOptimizations.enable = true;
    };
  };

  environment.systemPackages = [
    (pkgs.lutris.override {
      extraLibraries = pkgs: [
        # List library dependencies here
      ];
      extraPkgs = pkgs: [
        # List extra packages available to lutris here
      ];
    })

    pkgs.r2modman
    pkgs.ryujinx
  ];
}
