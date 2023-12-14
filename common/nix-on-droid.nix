{
  config,
  nur,
  ...
}: {
  imports = [
    ./vars.nix
    ./pkgs
    ./modules/global.nix
    nur.nixosModules.nur
  ];

  nix = {
    # Edit nix.conf
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      warn-dirty = false
    '';

    substituters = [
      # Neovim and stuff
      "https://nix-community.cachix.org"
    ];
    trustedPublicKeys = [
      # Neovim and stuff
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Global hm settings
  home-manager.config = {
    imports = [
      # Make the vars be the same on Nix and HM
      ./vars.nix
      {vars = config.vars;}

      nur.hmModules.nur

      ./home
      ./pkgs
    ];

    home.stateVersion = "23.05";
  };
}
