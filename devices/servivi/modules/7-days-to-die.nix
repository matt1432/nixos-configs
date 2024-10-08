{pkgs, ...}: let
  gamePath = "/var/lib/steam-servers/7-days-to-die";
  relativeConfig = "serverconfig-7days.xml";
in {
  services.borgbackup.configs."seven-days" = {
    paths = ["/var/lib/steam-servers/7-days-to-die"];
    startAt = "02/3:00";
  };

  systemd = {
    extraConfig = "DefaultLimitNOFILE=10240";

    services."7-days-to-die" = {
      wantedBy = ["multi-user.target"];
      serviceConfig.User = "matt";

      path = builtins.attrValues {
        inherit
          (pkgs)
          steam-run
          steamcmd
          ;
      };

      script = ''
        # Make sure gamePath exists and cd to it
        mkdir -p ${gamePath}
        cd ${gamePath}

        # Install / Update server
        steamcmd +force_install_dir ${gamePath} \
            +login anonymous +app_update 294420 \
            +quit

        # Launch server
        steam-run ./startserver.sh -configfile=${relativeConfig}
      '';
    };
  };
}
