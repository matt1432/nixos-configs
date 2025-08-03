{pkgs, ...}: let
  gamePath = "/var/lib/steam-servers/7-days-to-die";
  relativeConfig = "serverconfig-7days.xml";
in {
  services.borgbackup.configs."seven-days" = {
    paths = ["/var/lib/steam-servers/7-days-to-die"];
    startAt = "02/3:00";
  };

  nixpkgs.overlays = [
    (final: prev: {
      steam = prev.steam.override {
        extraPreBwrapCmds = ''
          mkdir -p "$HOME/.local/share/sevendays/"
        '';
        extraBwrapArgs = [
          ''--bind "${gamePath}/" "$HOME/.local/share/sevendays/"''
        ];
      };
    })
  ];

  systemd = {
    services."7-days-to-die" = {
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        User = "matt";
        Group = "users";
        LimitNOFILE = "10240";
      };

      path = builtins.attrValues {
        inherit
          (pkgs)
          steam-run
          steamcmd
          ;
      };

      script = ''
        # Install / Update server
        steamcmd +force_install_dir "$HOME/.local/share/sevendays" \
            +login anonymous +app_update 294420 \
            +quit

        # Launch server
        exec steam-run sh -c 'cd "$HOME/.local/share/sevendays"; \
            exec ./startserver.sh -configfile=${relativeConfig}'
      '';
    };
  };
}
