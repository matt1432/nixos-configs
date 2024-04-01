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
  node-syncsub = pkgs.callPackage ./node-syncsub {
    inherit subsync;
  };
in {
  environment.systemPackages = [subsync node-syncsub];

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
        node-syncsub
      ];

      script = ''
        find /data/movies -name '*.mkv' -printf "%h\0" | xargs -0 -I '{}' node-syncsub '{}' "eng,fra"
        # find /data/anime -name '*.mkv' -printf "%h\0" | xargs -0 -I '{}' node-syncsub '{}' "eng,fra"
        # find /data/tv -name '*.mkv' -printf "%h\0" | xargs -0 -I '{}' node-syncsub '{}' "eng,fra"
      '';
    };
    timers.subsync-job = {
      wantedBy = ["timers.target"];
      partOf = ["subsync-job.service"];
      timerConfig.OnCalendar = ["0:00:00"];
    };
  };
}
