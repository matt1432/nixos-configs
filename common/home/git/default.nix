{pkgs, ...}: {
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

      # https://github.com/dandavison/delta/issues/630#issuecomment-860046929
      extraConfig.pager = let
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
}
