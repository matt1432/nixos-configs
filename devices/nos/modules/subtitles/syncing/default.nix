{
  config,
  pkgs,
  pocketsphinx-src,
  subsync-src,
  ...
}: let
  inherit (config.vars) mainUser;

  subsync = pkgs.callPackage ./subsync {
    inherit pocketsphinx-src subsync-src;
  };
in {
  systemd = {
    services.subsync-job = {
      serviceConfig = {
        Type = "oneshot";
        User = mainUser;
        Group = config.users.users.${mainUser}.group;
      };

      path = with pkgs; [
        findutils
        subsync
      ];

      script = ''
        find /data/anime  -name '*.srt' -exec node-syncsub "{}" \;
        find /data/movies -name '*.srt' -exec node-syncsub "{}" \;
        find /data/tv     -name '*.srt' -exec node-syncsub "{}" \;
      '';
    };
    timers.subsync-job = {
      wantedBy = ["timers.target"];
      partOf = ["subsync-job.service"];
      timerConfig.OnCalendar = ["0:00:00"];
    };
  };
}
