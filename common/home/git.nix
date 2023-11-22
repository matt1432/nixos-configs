{pkgs, ...}: {
  programs = {
    git = {
      enable = true;
      lfs.enable = true;

      userName = "matt1432";
      userEmail = "matt@nelim.org";

      includes = [
        {path = "${pkgs.dracula-theme}/git-colors";}
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
