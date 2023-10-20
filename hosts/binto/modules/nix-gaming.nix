{ nix-gaming, pkgs, ... }: {
  imports = [
    nix-gaming.nixosModules.steamCompat
  ];

  programs.steam = {
    enable = true;

    extraCompatPackages = [
      # pkgs.luxtorpeda
      nix-gaming.packages.${pkgs.system}.proton-ge
    ];
  };
}
