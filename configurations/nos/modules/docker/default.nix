{...}: let
  configPath = "/var/lib/docker-data";
in {
  imports = [
    ./forgejo/compose.nix
    ./freshrss/compose.nix
    ./gameyfin/compose.nix
    ./hauk/compose.nix
    ./immich/compose.nix
    ./music/jbots/compose.nix
    ./nextcloud/compose.nix
    ./resume/compose.nix
    ./vaultwarden/compose.nix
    ./wg-easy/compose.nix

    ./media/bazarr/compose.nix
    ./media/joal/compose.nix
    ./media/prowlarr/compose.nix
    ./media/radarr/compose.nix
    ./media/sabnzbd/compose.nix
    ./media/seerr/compose.nix
    ./media/sonarr/compose.nix
  ];

  khepri = {
    rwDataDir = configPath;
  };

  services.borgbackup.configs.docker = {
    paths = [configPath];
  };
}
