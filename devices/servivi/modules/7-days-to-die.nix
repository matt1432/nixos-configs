{pkgs, ...}: let
  gamePath = "/var/lib/steam-servers/7-days-to-die";
  relativeConfig = "serverconfig-7days.xml";
in {
  systemd.extraConfig = "DefaultLimitNOFILE=10240";

  # TODO: make backups

  # https://github.com/Krutonium/NewNix/blob/455aafc4caf553248ca228f844f021cecf494dc2/services/sevendaystodie.nix#L6
  systemd.services."7-days-to-die" = {
    wantedBy = ["multi-user.target"];
    serviceConfig.User = "matt";

    path = with pkgs; [
      steam-run
      steamcmd
    ];

    script = ''
      # Make sure gamePath exists and cd to it
      mkdir -p ${gamePath}
      cd ${gamePath}

      # Install / Update server
      steamcmd +force_install_dir ${gamePath} \
          +login anonymous +app_update 294420 \
          -beta latest_experimental \
          +quit

      # Launch server
      steam-run ./startserver.sh -configfile=${relativeConfig}
    '';
  };
}
