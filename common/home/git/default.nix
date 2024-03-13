{
  config,
  pkgs,
  ...
}: let
  inherit (config.vars) mainUser;
in {
  programs = {
    git = {
      enable = true;
      lfs.enable = true;

      includes = [
        {path = "${pkgs.dracula-theme}/git-colors";}

        {
          condition = "hasconfig:remote.*.url:git@github.com:*/**";
          contents = {
            user = {
              email = "matt@nelim.org";
              name = "matt1432";
            };
          };
        }

        {
          condition = "hasconfig:remote.*.url:git@git.nelim.org:*/**";
          contents = {
            user = {
              email = "matt@nelim.org";
              name = "matt1432";
            };
          };
        }

        {
          condition = "hasconfig:remote.*.url:git@gitlab.info.uqam.ca:*/**";
          contents = {
            user = {
              email = "gj591944@ens.uqam.ca";
              name = "Mathis Hurtubise";
            };
          };
        }
      ];

      delta = {
        enable = true;
        options = {
          side-by-side = true;
          line-numbers-zero-style = "#E6EDF3"; #BD93F9";
        };
      };

      extraConfig = {
        diff.sopsdiffer.textconv = "sops --config /dev/null -d";

        # https://github.com/dandavison/delta/issues/630#issuecomment-860046929
        pager = let
          cmd = "LESS='LRc --mouse' ${pkgs.delta}/bin/delta";
        in {
          diff = cmd;
          show = cmd;
          stash = cmd;
          log = cmd;
          reflog = cmd;
        };
      };
    };
  };

  home.packages = with pkgs; [
    (writeShellApplication {
      name = "chore";
      runtimeInputs = [git];

      text = ''
        DIR=''${1:-"/home/${mainUser}/.nix"}

        cd "$DIR"
        git add flake.lock
        git commit -m 'chore: update flake.lock'
        git push
      '';
    })
  ];
}
