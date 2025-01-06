self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.bash;

  mkRemoteConf = remote: email: name: {
    condition = "hasconfig:remote.*.url:${remote}*/**";
    contents.user = {inherit email name;};
  };
  mkDefaultRemote = remote: mkRemoteConf remote "matt@nelim.org" "matt1432";
in {
  config.programs = mkIf cfg.enable {
    git = {
      enable = true;
      package = pkgs.gitFull;

      lfs.enable = true;

      includes = [
        {path = toString self.scopedPackages.${pkgs.system}.dracula.git;}

        (mkDefaultRemote "https://github.com")
        (mkDefaultRemote "git@github.com")
        (mkDefaultRemote "git@git.nelim.org")

        (mkRemoteConf "git@gitlab.info.uqam.ca" "gj591944@ens.uqam.ca" "Mathis Hurtubise")
      ];

      delta = {
        enable = true;
        options = {
          side-by-side = true;
          line-numbers-zero-style = "#E6EDF3";
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

        sendemail = {
          smtpserver = "127.0.0.1";
          smtpuser = "matt@nelim.org";
          smtpencryption = "tls";
          smtpserverport = 1025;
          smtpsslcertpath = "";
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
