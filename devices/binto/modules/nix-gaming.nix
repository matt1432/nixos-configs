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

      extraCompatPackages = [
        nix-gaming.packages.${pkgs.system}.proton-ge
      ];
    };
  };
}
