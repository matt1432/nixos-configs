{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) getExe;
  inherit (pkgs.writers) writeYAML;
in {
  systemd.services.home-assistant.preStart = let
    WorkingDirectory = "/var/lib/hass";
    creds = config.sops.secrets.spotifyd.path;
    spotify = writeYAML "assist_spotify.yaml" (import ./spotify-sentences.nix);
  in
    getExe (pkgs.writeShellApplication {
      name = "spotify-files";
      text = ''
        mkdir -p ${WorkingDirectory}/custom_sentences/en
        cp -f ${spotify} ${WorkingDirectory}/custom_sentences/en
        cp -f ${creds} ${WorkingDirectory}/.storage/SpotifyWebApiPython_librespot_credentials.json
      '';
    });

  services.home-assistant = {
    customComponents = builtins.attrValues {
      inherit
        (self.legacyPackages.${pkgs.system}.hass-components)
        spotifyplus
        ;
    };

    extraComponents = [
      "spotify"
    ];

    config.intent_script = {
      PlayArtist = {
        async_action = "false";
        action = [
          {
            service = "netdaemon.spotify_play_artist";
            data.criteria = "{{ artist }}";
          }
        ];
      };
    };
  };
}
