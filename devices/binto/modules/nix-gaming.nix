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
      enable = true;

      extraCompatPackages = [
        nix-gaming.packages.${pkgs.system}.proton-ge
      ];
    };
  };
}
