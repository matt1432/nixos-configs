{ nix-gaming, pkgs, ... }: {
  nix.settings = {
    substituters = ["https://nix-gaming.cachix.org"];
    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };

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
