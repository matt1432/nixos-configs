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
      # Personal config cache
      "https://cache.nelim.org"
    ];
    trustedPublicKeys = [
      # Neovim and stuff
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # Personal config cache
      "cache.nelim.org:JmFqkUdH11EA9EZOFAGVHuRYp7EbsdJDHvTQzG2pPyY="
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
          pc = "ssh -t matt@100.64.0.6 'tmux -2u new -At phone'";
          oksys = "ssh -t matt@100.64.0.1 'tmux -2u new -At phone'";
          servivi = "ssh -t matt@100.64.0.7 'tmux -2u new -At phone'";
          pve = "ssh -t matt@100.64.0.4 'tmux -2u new -At phone'";

          pod = "mosh matt@100.64.0.4 -- ssh -t -p 6768 matt@10.0.0.122 'tmux -2u new -At phone'";
          jelly = "mosh matt@100.64.0.4 -- ssh -t matt@10.0.0.123 'tmux -2u new -At phone'";
          qbit = "mosh matt@100.64.0.4 -- ssh -t matt@10.0.0.128 'tmux -2u new -At phone'";
        };
      }
    ];

    home.stateVersion = "23.05";
  };
}
