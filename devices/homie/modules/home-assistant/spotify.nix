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

    config = {
      script.play_artist = {
        alias = "Spotify - Play Artist";
        sequence = [
          {
            sequence = [
              {
                action = "spotifyplus.search_artists";
                data = {
                  entity_id = "media_player.spotifyplus";
                  criteria = ''{{ criteria }}'';
                  limit = 1;
                };
                response_variable = "sp_results";
              }
              {
                action = "spotifyplus.player_media_play_context";
                data = {
                  entity_id = "media_player.spotifyplus";
                  context_uri = ''
                    {% for item in sp_results.result | dictsort %}
                      {% if item[0] == 'items' %}
                        {{ item[1][0].uri }}
                        {% break %}
                      {% endif %}
                    {%- endfor %}
                  '';
                };
              }
            ];
          }
        ];
      };
    };
  };
}
