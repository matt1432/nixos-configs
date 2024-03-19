{
  nix-gaming,
  pkgs,
  ...
}: {
  programs = {
    steam = {
      # Disable HW accel to fix flickers
      enable = true;
      remotePlay.openFirewall = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
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
