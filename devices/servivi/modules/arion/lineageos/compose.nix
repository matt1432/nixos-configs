{
  config,
  rwPath,
  ...
}: let
  secrets = config.sops.secrets;
in {
  # FIXME: crashes when building

  # This should only be ran when an update is needed
  enabled = false;

  services = {
    "builder" = {
      image = "lineageos4microg/docker-lineage-cicd";
      container_name = "lineage_builder";

      environment = {
        BRANCH_NAME = "lineage-20.0";
        DEVICE_LIST = "lemonadep";
        SIGN_BUILDS = "true";
        SIGNATURE_SPOOFING = "restricted";
        WITH_GMS = "true";
        ZIP_SUBDIR = "false";
        OTA_URL = "https://ota.nelim.org/api";
        CUSTOM_PACKAGES = "AuroraStore AvesLibre Droidify MJPdfReader Mull OpenCalc";
        INCLUDE_PROPRIETARY = "false";
        PARALLEL_JOBS = 6;
        CLEAN_AFTER_BUILD = "false";
        CCACHE_SIZE = "200G";
      };

      volumes = [
        "${rwPath}/lineage/src:/srv/src"
        "${rwPath}/lineage/zips:/srv/zips"
        "${rwPath}/lineage/logs:/srv/logs"
        "${rwPath}/lineage/cache:/srv/ccache"
        "${rwPath}/lineage/keys:/srv/keys"

        "${toString ./.}/manifests:/srv/local_manifests:ro"
        "${toString ./.}/scripts:/srv/userscripts:ro"
        "/etc/timezone:/etc/timezone:ro"
        "/etc/localtime:/etc/localtime:ro"
      ];
    };

    "OTA-server" = {
      container_name = "lineageOTA";
      image = "docker.io/julianxhokaxhiu/lineageota";
      volumes = [
        "${rwPath}/lineage/zips:/var/www/html/builds/full:ro"
      ];
    };

    "caddy" = {
      image = "quay.io/slothcroissant/caddy-cloudflaredns:latest";
      container_name = "caddy";

      ports = [
        "80:80"
        "443:443"
      ];

      volumes = [
        "${rwPath}/caddy/data:/data"
        "${rwPath}/caddy/config:/config"

        "${toString ./.}/Caddyfile:/etc/caddy/Caddyfile:ro"
      ];

      env_file = [secrets.caddy-cloudflare.path];
      environment = {
        CLOUDFLARE_EMAIL = "matt@nelim.rg";
        ACME_AGREE = "true";
      };
    };
  };
}
