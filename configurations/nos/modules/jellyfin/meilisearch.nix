{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;

  jellyService = config.systemd.services.jellyfin.serviceConfig;
in {
  # The Meilisearch plugin connects on Jellyfin startup, so Meilisearch has to be up first.
  systemd.services = {
    jellyfin = {
      wants = ["compose-meilisearch.service"];
      after = ["compose-meilisearch.service"];
    };

    # compose-meilisearch is Type=simple, so wait for the API before it counts as started.
    compose-meilisearch.postStart = ''
      until ${getExe pkgs.curl} -fsS -o /dev/null http://127.0.0.1:7700/health; do
        sleep 1
      done
    '';
  };

  virtualisation.docker.compose."meilisearch" = {
    networks.proxy_net = {external = true;};

    services."meilisearch" = {
      image = pkgs.callPackage ./images/meilisearch.nix pkgs;
      restart = "always";

      command = ["/bin/meilisearch" "--upgrade-db"];

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
