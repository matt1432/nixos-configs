{
  config,
  self,
  ...
}: {
  imports = [
    self.nixosModules.base-droid
    {
      roles.base = {
        enable = true;
        user = "nix-on-droid";
      };
    }

    self.nixosModules.tmux
    {programs.tmux.enableCustomConf = true;}
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
      # Nix-community
      "https://nix-community.cachix.org"

      # Personal cache
      "https://cache.nelim.org"
    ];

    trustedPublicKeys = [
      # Nix-community
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="

      # Personal cache
      "cache.nelim.org:JmFqkUdH11EA9EZOFAGVHuRYp7EbsdJDHvTQzG2pPyY="
    ];
  };

  # Global hm settings
  home-manager.config = {
    imports = [
      self.homeManagerModules.neovim
      {
        programs.neovim = {
          enable = true;
          user = "nix-on-droid";

          ideConfig = {
            enableJava = false;
            enableNix = false;
          };
        };
      }

      self.homeManagerModules.shell
      {programs.bash.enable = true;}

      {
        programs.bash.sessionVariables = {
          FLAKE = config.environment.variables.FLAKE;
        };

        programs.bash.shellAliases = {
          # Make ping work on nix-on-droid
          # https://github.com/nix-community/nix-on-droid/issues/185#issuecomment-1659294700
          ping = "/android/system/bin/linker64 /android/system/bin/ping";

          # SSH
          # Desktop
          pc = "ssh -t matt@100.64.0.6 'tmux -2u new -At phone'";

          # NAS
          nos = "ssh -t matt@100.64.0.4 'tmux -2u new -At phone'";

          # Experimenting server
          servivi = "ssh -t matt@100.64.0.7 'tmux -2u new -At phone'";

          # Home-assistant
          homie = "ssh -t matt@100.64.0.10 'tmux -2u new -At phone'";

          # Cluster nodes
          thingone = "ssh -t matt@100.64.0.8 'tmux -2u new -At phone'";
          thingtwo = "ssh -t matt@100.64.0.9 'tmux -2u new -At phone'";
        };
      }
    ];

    home.stateVersion = "23.05";
  };
}
