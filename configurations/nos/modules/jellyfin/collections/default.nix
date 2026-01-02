{...}: {
  imports = [./jellyfin-auto-collections.nix];

  services.jellyfin-auto-collections = {
    enable = true;

    # https://github.com/ghomasHudson/Jellyfin-Auto-Collections/blob/master/config.yaml.example
    settings = {
      crontab = "0 0 * * *";
      timezone = "America/New_York";

      jellyfin = {
        api_key = "!ENV \${JELLYFIN_API_KEY}";
        user_id = "!ENV \${JELLYFIN_USER_ID}";
        server_url = "https://jelly.nelim.org";
      };

      plugins = {
        letterboxd = {
          enabled = false;
          clear_collection = true;
          imdb_id_filter = true;
          list_ids = [
            {
              list_name = "MCU Test";
              list_id = "arinbicer/list/mcu";
            }
          ];
        };

        arr.enabled = false;
        bfi.enabled = false;
        criterion_channel.enabled = false;
        imdb_chart.enabled = false;
        imdb_list.enabled = false;
        jellyfin_api.enabled = false;
        listmania.enabled = false;
        mdblist.enabled = false;
        popular_movies.enabled = false;
        trakt.enabled = false;
        tspdt.enabled = false;
      };
    };
  };
}
