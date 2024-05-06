{
  config,
  pkgs,
  ...
}: let
  inherit (config.vars) mainUser;

  scriptSrc = pkgs.fetchFromGitHub {
    owner = "brianspilner01";
    repo = "media-server-scripts";
    rev = "00d9efcd37bb2667d23d7747240b59291cde64d3";
    hash = "sha256-Qql6Z+smU8vEJaai0POjdMnYpET9ak4NddNQevEQ8Ds=";
  };

  script = pkgs.concatTextFile {
    name = "sub-clean.sh";
    files = ["${scriptSrc}/sub-clean.sh"];
    executable = true;
  };
in {
  systemd = {
    services.sub-clean = {
      serviceConfig = {
        Type = "oneshot";
        User = mainUser;
        Group = config.users.users.${mainUser}.group;
      };

      path = [
        pkgs.findutils

        (pkgs.writeShellApplication {
          name = "sub-clean";
          runtimeInputs = with pkgs; [findutils gnugrep gawk];
          text = ''
            exec ${script} "$@"
          '';
        })
      ];

      script = ''
        find /data/anime  -name '*.srt' -exec sub-clean "{}" \;
        find /data/movies -name '*.srt' -exec sub-clean "{}" \;
        find /data/tv     -name '*.srt' -exec sub-clean "{}" \;
      '';
    };
    timers.sub-clean = {
      wantedBy = ["timers.target"];
      partOf = ["sub-clean.service"];
      timerConfig.OnCalendar = ["0:00:00"];
    };
  };
}
