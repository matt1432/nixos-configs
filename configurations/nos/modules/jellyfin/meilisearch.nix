{
  config,
  pkgs,
  ...
}: let
  jellyService = config.systemd.services.jellyfin.serviceConfig;
in {
  virtualisation.docker.compose."meilisearch" = {
    systemdDependencies = ["jellyfin.service"];

    networks.proxy_net = {external = true;};

    services."meilisearch" = {
      image = pkgs.callPackage ./images/meilisearch.nix pkgs;
      restart = "always";

      command = ["/bin/meilisearch" "--experimental-dumpless-upgrade"];

      networks = ["proxy_net"];

      ports = ["7700:7700"];
      environment = {
        MEILI_MASTER_KEY = "1234";
        MEILI_NO_ANALYTICS = "true";
      };

      volumes = [
        "${jellyService.WorkingDirectory}/meilisearch:/meili_data"
        "/etc/localtime:/etc/localtime:ro"
      ];
    };
  };
}
