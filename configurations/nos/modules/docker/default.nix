{...}: let
  configPath = "/var/lib/docker-data";
in {
  imports = [
    (import ./forgejo/compose.nix configPath)
    (import ./freshrss/compose.nix configPath)
    (import ./gameyfin/compose.nix configPath)
    (import ./hauk/compose.nix configPath)
    (import ./immich/compose.nix configPath)
    (import ./music/jbots/compose.nix configPath)
    (import ./nextcloud/compose.nix configPath)
    (import ./resume/compose.nix configPath)
    (import ./vaultwarden/compose.nix configPath)
    (import ./wg-easy/compose.nix configPath)

    (import ./media/bazarr/compose.nix configPath)
    (import ./media/joal/compose.nix configPath)
    (import ./media/jellystat/compose.nix configPath)
    (import ./media/prowlarr/compose.nix configPath)
    (import ./media/radarr/compose.nix configPath)
    (import ./media/seerr/compose.nix configPath)
    (import ./media/sonarr/compose.nix configPath)
  ];

  services.borgbackup.configs.docker = {
    paths = [configPath];
  };
}
