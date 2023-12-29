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

  environment.systemPackages = with pkgs; [
    (lutris.override {
      extraLibraries = pkgs: [
        # List library dependencies here
      ];
      extraPkgs = pkgs: [
        nix-gaming.packages.${pkgs.system}.wine-ge
      ];
    })
  ];
}
