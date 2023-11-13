{pkgs, ...}: {
  programs = {
    git = {
      enable = true;
      lfs.enable = true;

      userName = "matt1432";
      userEmail = "matt@nelim.org";

      includes = [
        {
          path = "${
            pkgs.fetchFromGitHub {
              owner = "dracula";
              repo = "git";
              rev = "924d5fc32f7ca15d0dd3a8d2cf1747e81e063c73";
              hash = "sha256-3tKjKn5IHIByj+xgi2AIL1vZANlb0vlYJsPjH6BHGxM=";
            }
          }/git-colors";
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
