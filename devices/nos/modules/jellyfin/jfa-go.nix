{config, ...}: let
  jellyService = config.systemd.services.jellyfin.serviceConfig;
in {
  systemd.services."arion-jfa-go" = {
    after = ["jellyfin.service"];
    partOf = ["jellyfin.service"];
  };

  arion.projects."jfa-go"."jfa-go" = {
    image = ./images/jfa-go.nix;
    restart = "always";

    ports = ["8056:8056"];

    volumes = [
      "${jellyService.WorkingDirectory}/jfa-go:/data"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}
