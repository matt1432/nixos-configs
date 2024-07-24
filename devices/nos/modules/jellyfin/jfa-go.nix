{
  config,
  pkgs,
  ...
}: let
  jellyService = config.systemd.services.jellyfin.serviceConfig;
in {
  systemd.services."docker-jfa-go_jfa-go" = {
    after = ["jellyfin.service"];
    partOf = ["jellyfin.service"];
  };

  khepri.compositions."jfa-go".services."jfa-go" = {
    image = import ./images/jfa-go.nix pkgs;
    restart = "always";

    ports = ["8056:8056"];

    volumes = [
      "${jellyService.WorkingDirectory}/jfa-go:/data"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}
