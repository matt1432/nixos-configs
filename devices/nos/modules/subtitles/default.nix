{
  config,
  pkgs,
  ...
}: let
  inherit (config.vars) mainUser;

  convertMkv = pkgs.callPackage ./convert.nix {inherit pkgs;};
  exportSubs = pkgs.callPackage ./extract-subs {inherit pkgs;};
  sub-clean = pkgs.callPackage ./cleanup.nix {inherit pkgs;};
in {
  imports = [
    ./syncing.nix
    # TODO:
    # - Improve cleanup
    # - Sync with bazarr-bulk
    # - figure out bazarr postprocessing with subsync
  ];
  systemd = {
    services.manage-subs = {
      serviceConfig = {
        Type = "oneshot";
        User = mainUser;
        Group = config.users.users.${mainUser}.group;
      };

      path = [
        convertMkv
        exportSubs
        sub-clean
      ];

      script = ''
        # Make sure every video file is a mkv
        find /data/{anime,history,movies,tv} -name '*.mp4' -exec convertMkv "mp4" "{}" \;

        # Export subs from mkv files
        find /data/{anime,history,movies,tv} -name '*.mkv' -printf "%h\0" |
        xargs -0 -I '{}' extract-subs '{}' "eng,fre"

        # Remove ads and stuff in subs
        find /data/{anime,history,movies,tv} -name '*.srt' -exec sub-clean "{}" \;
      '';
    };

    /*
    timers.sub-clean = {
      wantedBy = ["timers.target"];
      partOf = ["manage-subs.service"];
      timerConfig.OnCalendar = ["0:00:00"];
    };
    */
  };
}
