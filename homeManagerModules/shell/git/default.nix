self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe mkIf;

  cfg = config.programs.bash;

  mkRemoteConf = remote: email: name: {
    condition = "hasconfig:remote.*.url:${remote}*/**";
    contents.user = {inherit email name;};
  };
  mkDefaultRemote = remote: mkRemoteConf remote "matt@nelim.org" "matt1432";

  mkGitAlias = script: "!${getExe script}";
in {
  config.programs = mkIf cfg.enable {
    delta = {
      enable = true;
      enableGitIntegration = true;

      options = {
        side-by-side = true;
        line-numbers-zero-style = "#E6EDF3";
      };
    };

    git = {
      enable = true;
      package = pkgs.gitFull;

      lfs.enable = true;

      signing.format = "ssh";

      includes = [
        {path = toString pkgs.scopedPackages.dracula.git;}

        (mkDefaultRemote "https://github.com")
        (mkDefaultRemote "git@github.com")
        (mkDefaultRemote "ssh://git@git.nelim.org")

        (mkRemoteConf "git@gitlab.info.uqam.ca" "gj591944@ens.uqam.ca" "Mathis Hurtubise")
      ];

      settings = {
        help.autocorrect = "prompt";

        alias = {
          diff-clean = "-c delta.side-by-side=false diff";
          diff-patch = "-c delta.side-by-side=false -c delta.keep-plus-minus-markers=true diff";

          # https://stackoverflow.com/a/18317425
          ignore = "update-index --assume-unchanged";
          unignore = "update-index --no-assume-unchanged";
          ignored = "!git ls-files -v | ${getExe pkgs.gnugrep} \"^[[:lower:]]\"";

          untracked-ignore = mkGitAlias (pkgs.writeShellApplication {
            name = "untracked-ignore";
            text = ''
              if [ $# -eq 0 ]; then
                  echo "No file names provided"
                  exit 1
              fi
              for arg in "$@"; do
                  echo -e "$arg\n" >> .git/info/exclude
              done
            '';
          });
          untracked-unignore = mkGitAlias (pkgs.writeShellApplication {
            name = "untracked-unignore";
            text = ''
              if [ $# -eq 0 ]; then
                  echo "No file names provided"
                  exit 1
              fi
              for arg in "$@"; do
                  sed -i "s/$arg//" .git/info/exclude
              done
            '';
          });
          untracked-ignored = mkGitAlias (pkgs.writeShellApplication {
            name = "untracked-ignored";
            text = ''
              while IFS= read -r line; do
                  if [[ "$line" != "" ]] && [[ "$line" != "#"* ]]; then
                      echo "$line"
                  fi
              done < .git/info/exclude
            '';
          });
        };

        diff.sopsdiffer.textconv = "sops decrypt";

        sendemail = {
          smtpserver = "127.0.0.1";
          smtpuser = "matt@nelim.org";
          smtpencryption = "tls";
          smtpserverport = 1025;
          smtpsslcertpath = "";
        };
      };
    };

    # https://github.com/dandavison/delta/issues/630#issuecomment-2003149860
    bash.sessionVariables.LESS = "-R --mouse";
  };

  # For accurate stack trace
  _file = ./default.nix;
}
