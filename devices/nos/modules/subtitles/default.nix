{
  config,
  mainUser,
  pkgs,
  ...
} @ inputs: let
  convertMkv = pkgs.callPackage ./convert.nix {inherit pkgs;};
  extractSubs = pkgs.callPackage ./extract-subs {inherit pkgs;};
  sub-clean = pkgs.callPackage ./cleanup.nix {inherit pkgs;};
  bazarr-bulk = pkgs.callPackage ./syncing.nix inputs;
in {
  # TODO:
  # - Improve cleanup
  # - figure out bazarr postprocessing with syncing subs

  environment.systemPackages = [
    bazarr-bulk
  ];

  systemd = {
    services.manage-subs = {
      serviceConfig = {
        User = mainUser;
        Group = config.users.users.${mainUser}.group;
      };

      path = [
        convertMkv
        extractSubs
        sub-clean
        bazarr-bulk
      ];

      script = ''
        # Make sure every video file is a mkv
        find /data/{anime,history,movies,tv} -name '*.mp4' -exec convertMkv "mp4" "{}" \;

        # Export subs from mkv files
        find /data/{anime,history,movies,tv} -name '*.mkv' -printf "%h\0" |
        xargs -0 -I '{}' extract-subs '{}' "eng,fre"

        # Remove ads and stuff in subs
        find /data/{anime,history,movies,tv} -name '*.srt' -exec sub-clean "{}" \;

        # Bulk sync everything
        bb movies sync
        bb tv-shows sync
      '';
    };

    timers.manage-subs = {
      wantedBy = ["timers.target"];
      partOf = ["manage-subs.service"];
      timerConfig.OnCalendar = ["0:00:00"];
    };
  };
}
