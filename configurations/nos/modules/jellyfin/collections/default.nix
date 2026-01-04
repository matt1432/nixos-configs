{pkgs, ...}: {
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
          enabled = true;
          clear_collection = true;
          imdb_id_filter = true;
          list_ids = [
            {
              list_name = "MCU Collection";
              list_id = "arinbicer/list/mcu";
              images = {
                primary = pkgs.fetchurl {
                  url = "https://git.nelim.org/matt1432/pub-images/raw/commit/0bb39c73837a03519f5bb2d68e5c3ff69adac266/jellyfin-collections/mcu/Primary.png";
                  hash = "sha256-aGTy+F/DoyKUmkR+s5F0apwQnTMc/ZPU7z+khlllwK4=";
                };
                backdrop = pkgs.fetchurl {
                  url = "https://git.nelim.org/matt1432/pub-images/raw/commit/0bb39c73837a03519f5bb2d68e5c3ff69adac266/jellyfin-collections/mcu/Backdrop.jpg";
                  hash = "sha256-T2F16N5h4qKjztGw6fOKRnpW9cfPvANv32sEiCJKzc8=";
                };
              };
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
