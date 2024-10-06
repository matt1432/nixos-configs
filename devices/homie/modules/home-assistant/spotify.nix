{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) getExe;
in {
  systemd.services.home-assistant.preStart = let
    WorkingDirectory = "/var/lib/hass";
    creds = config.sops.secrets.spotifyd.path;
  in
    getExe (pkgs.writeShellApplication {
      name = "spotify-plus-creds";
      text = ''
        cp -f ${creds} ${WorkingDirectory}/.storage/SpotifyWebApiPython_librespot_credentials.json
      '';
    });

  services.home-assistant = {
    # Needed for spotifyplus
    package = pkgs.home-assistant.override {
      packageOverrides = _: super: {
        inherit (self.packages.${pkgs.system}) urllib3;
      };
    };

    customComponents = builtins.attrValues {
      inherit
        (self.legacyPackages.${pkgs.system}.hass-components)
        spotifyplus
        ;
    };

    extraComponents = [
      "spotify"
    ];
  };
}
