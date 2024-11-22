{
  config,
  lib,
  self,
  ...
}: {
  imports = [
    ../../common/vars
    ../../common/modules/global.nix
    ../../common/packages.nix

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
    ];
    trustedPublicKeys = [
      # Nix-community
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Global hm settings
  home-manager.config = {
    imports = [
      # Make the vars be the same on Nix and HM
      {
        options.vars = lib.mkOption {
          type = lib.types.attrs;
          readOnly = true;
          default = config.vars;
        };
      }

      self.homeManagerModules.neovim
      {programs.neovim.enable = true;}

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
