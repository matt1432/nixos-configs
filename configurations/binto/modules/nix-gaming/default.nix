{
  mainUser,
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
        pkgs.scopedPackages.protonGE.latest

        # For Marvel Rivals
        pkgs.scopedPackages.protonGE.v10-20
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
    pkgs.ryubing
  ];

  # https://wiki.nixos.org/wiki/Lutris Esync
  systemd.settings.Manager.DefaultLimitNOFILE = 524288;
  security.pam.loginLimits = [
    {
      domain = mainUser;
      type = "hard";
      item = "nofile";
      value = "524288";
    }
  ];
}
