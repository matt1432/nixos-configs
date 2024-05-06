{
  config,
  pkgs,
  subsync,
  ...
}: let
  inherit (config.vars) mainUser;

  subsyncPkg = subsync.packages.${pkgs.system}.default;

  node-syncsub = pkgs.callPackage ./node-syncsub {
    subsync = subsyncPkg;
  };
in {
  environment.systemPackages = [subsyncPkg node-syncsub];

  systemd = {
    services.subsync-job = {
      serviceConfig = {
        Type = "oneshot";
        User = mainUser;
        Group = config.users.users.${mainUser}.group;
      };

      path = [
        pkgs.findutils
        node-syncsub
      ];

      script = ''
        find /data/movies -name '*.mkv' -printf "%h\0" | xargs -0 -I '{}' node-syncsub '{}' "eng,fre"
        # find /data/anime -name '*.mkv' -printf "%h\0" | xargs -0 -I '{}' node-syncsub '{}' "eng,fre"
        # find /data/tv -name '*.mkv' -printf "%h\0" | xargs -0 -I '{}' node-syncsub '{}' "eng,fre"
      '';
    };
    #timers.subsync-job = {
    #  wantedBy = ["timers.target"];
    #  partOf = ["subsync-job.service"];
    #  timerConfig.OnCalendar = ["0:00:00"];
    #};
  };
}
