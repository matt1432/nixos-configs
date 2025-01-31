{
  config,
  pkgs,
  ...
}: let
  jellyService = config.systemd.services.jellyfin.serviceConfig;
in {
  virtualisation.docker.compose."jfa-go" = {
    systemdDependencies = ["jellyfin.service"];

    networks.proxy_net = {external = true;};

    services."jfa-go" = {
      image = pkgs.callPackage ./images/jfa-go.nix pkgs;
      restart = "always";

      ports = ["8056:8056"];
      networks = ["proxy_net"];

      volumes = [
        "${jellyService.WorkingDirectory}/jfa-go:/data"
        "/etc/localtime:/etc/localtime:ro"
      ];
    };
  };
}
