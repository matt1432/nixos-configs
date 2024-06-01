{
  config,
  nix-gaming,
  pkgs,
  ...
}: let
  inherit (config.vars) mainUser;

  wine = nix-gaming.packages.${pkgs.system}.wine-ge;
in {
  imports = [
    nix-gaming.nixosModules.platformOptimizations
  ];

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
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
        wine
      ];
    })

    pkgs.r2modman
  ];

  # Give wine a constant path for lutris
  home-manager.users.${mainUser}.home.file = {
    ".bin/wine".source = "${wine}/bin/wine";
  };
}
