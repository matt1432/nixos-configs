{
  nix-gaming,
  pkgs,
  ...
}: {
  imports = [
    nix-gaming.nixosModules.steamCompat
  ];

  programs = {
    steam = {
      # Disable HW accel to fix flickers
      enable = true;
      remotePlay.openFirewall = true;

      extraCompatPackages = [
        nix-gaming.packages.${pkgs.system}.proton-ge
      ];
    };
  };
}
