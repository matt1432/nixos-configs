{...}: let
  globalEnv = {
    configPath = "/var/lib/docker-data";
    mainUID = "1000";
    mainGID = "1000";
    TZ = "America/New_York";
  };
in {
  imports = [
    (import ./forgejo/compose.nix globalEnv)
    (import ./freshrss/compose.nix globalEnv)
    (import ./gameyfin/compose.nix globalEnv)
    (import ./hauk/compose.nix globalEnv)
    (import ./immich/compose.nix globalEnv)
    (import ./music/jbots/compose.nix globalEnv)
    (import ./nextcloud/compose.nix globalEnv)
    (import ./resume/compose.nix globalEnv)
    (import ./vaultwarden/compose.nix globalEnv)
    (import ./wg-easy/compose.nix globalEnv)

    (import ./media/bazarr/compose.nix globalEnv)
    (import ./media/joal/compose.nix globalEnv)

    # Crashes jellyfin
    # (import ./media/jellystat/compose.nix globalEnv)

    (import ./media/prowlarr/compose.nix globalEnv)
    (import ./media/radarr/compose.nix globalEnv)
    (import ./media/seerr/compose.nix globalEnv)
    (import ./media/sonarr/compose.nix globalEnv)
  ];

  services.borgbackup.configs.docker = {
    paths = [globalEnv.configPath];
  };
}
