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

      {
        programs.bash.shellAliases = {
          pc = "mosh matt@binto -- tmux -2u new -At laptop";
          oksys = "mosh matt@oksys -- tmux -2u new -At laptop";
          pve = "mosh matt@pve -- tmux -2u new -At laptop";

          mc = "mosh mc@mc -- tmux -2u new -At laptop";
          pod = "mosh matt@pve -- ssh -t -p 6768 matt@10.0.0.122 'tmux -2u new -At laptop'";
          jelly = "mosh matt@pve -- ssh -t matt@10.0.0.123 'tmux -2u new -At laptop'";
          qbit = "mosh matt@pve -- ssh -t matt@10.0.0.128 'tmux -2u new -At laptop'";
        };
      }
    ];

    home.stateVersion = "23.05";
  };
}
