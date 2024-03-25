{
  config,
  pkgs,
  ...
}: let
  inherit (config.vars) mainUser;

  sphinxbase = pkgs.callPackage ./sphinxbase.nix {};
  pocketsphinx = pkgs.callPackage ./pocketsphinx.nix {inherit sphinxbase;};
  subsync = pkgs.callPackage ./subsync.nix {inherit sphinxbase pocketsphinx;};
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
        (writeShellApplication {
          name = "sync-sub";
          runtimeInputs = [subsync];
          text = ''
            # TODO: sync on a specific file
            # $1 = file path
          '';
        })
      ];

      script = ''
        find /data/anime  -name '*.srt' -exec sync-sub "{}" \;
        find /data/movies -name '*.srt' -exec sync-sub "{}" \;
        find /data/tv     -name '*.srt' -exec sync-sub "{}" \;
      '';
    };
    timers.subsync-job = {
      wantedBy = ["timers.target"];
      partOf = ["subsync-job.service"];
      timerConfig.OnCalendar = ["0:00:00"];
    };
  };
}
