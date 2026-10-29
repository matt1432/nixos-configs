# NOTE: Stopgap for the eMudhra CA compromise
{
  config,
  lib,
  ...
}: let
  inherit (builtins) listToAttrs mapAttrs;
  inherit (lib) mkMerge;

  caMount = "${config.security.pki.caBundle}:/etc/ssl/certs/ca-certificates.crt:ro";

  staleImages = {
    "cleanuparr" = ["cleanuparr"];
    "forgejo" = ["runner"];
    "freshrss" = ["freshrss" "bridge.nelim.org"];
    "gameyfin" = ["gameyfin"];
    "hauk" = ["hauk"];
    "immich" = ["immich_server" "immich_machine_learning" "immich_redis" "immich_postgres"];
    "jdownloader2" = ["jdownloader2"];
    "jfa-go" = ["jfa-go"];
    "joal" = ["joal"];
    "nextcloud" = ["app-server" "onlyoffice-document-server" "nginx-server" "nextcloud-db" "nextcloud-cache"];
    "prowlarr" = ["flaresolverr"];
    "qbit" = ["gluetun"];
    "seerr" = ["seerr"];
    "vaultwarden" = ["public-vault" "private-vault"];
  };

  # Python apps using requests read certifi's bundled store instead
  certifiImages = {
    "bazarr" = ["bazarr"];
    "immich" = ["immich_machine_learning"];
    "nextcloud" = ["onlyoffice-document-server"];
    "prowlarr" = ["flaresolverr"];
  };

  forServices = projects: f:
    mapAttrs (_: services: {
      services = listToAttrs (map (name: {
          inherit name;
          value = f;
        })
        services);
    })
    projects;
in {
  virtualisation.docker.compose = mkMerge [
    (forServices staleImages {volumes = [caMount];})
    (forServices certifiImages {
      environment.REQUESTS_CA_BUNDLE = "/etc/ssl/certs/ca-certificates.crt";
    })
  ];
}
