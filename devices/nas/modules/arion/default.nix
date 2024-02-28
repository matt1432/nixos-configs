{...}: let
  configPath = "/var/lib/arion";
in {
  imports = [
    ../../../../modules/arion.nix

    ./forgejo/compose.nix
    ./freshrss/compose.nix
    ./hauk/compose.nix
    ./homepage/compose.nix
    ./immich/compose.nix
    ./music/jbots/compose.nix
    ./nextcloud/compose.nix
  ];

  arion = {
    enable = true;
    rwDataDir = configPath;
  };

  services.borgbackup.configs.arion = {
    paths = [configPath];
    exclude = ["**/lineageos*"];
  };
}
