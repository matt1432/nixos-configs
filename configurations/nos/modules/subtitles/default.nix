{
  config,
  mainUser,
  pkgs,
  self,
  ...
} @ extraArgs: let
  inherit (self.appsPackages.${pkgs.system}) extract-subs;
  inherit (self.packages.${pkgs.system}) subscleaner;

  convert-mkv = pkgs.callPackage ./convert.nix {};
  bazarr-bulk = pkgs.callPackage ./syncing.nix ({} // extraArgs);
in {
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
        bazarr-bulk
        convert-mkv
        extract-subs
        subscleaner
      ];

      script = ''
        # Make sure every video file is a mkv
        find /data/{anime,history,movies,tv} -name '*.mp4' -exec convert-mkv "mp4" "{}" \;

        # Export subs from mkv files
        find /data/{anime,history,movies,tv} -name '*.mkv' -printf "%h\0" |
        xargs -0 -I '{}' extract-subs '{}' "eng,fre"

        # Remove ads and stuff in subs
        find /data/{anime,history,movies,tv} -name '*.srt' | subscleaner

        # Bulk sync everything
        # bb movies sync
        # bb tv-shows sync
      '';
    };

    timers.manage-subs = {
      wantedBy = ["timers.target"];
      partOf = ["manage-subs.service"];
      timerConfig.OnCalendar = ["0:00:00"];
    };
  };
}
