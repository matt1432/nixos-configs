{my-images-src, ...}: {
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
                primary = "${my-images-src}/jellyfin-collections/mcu/Primary.png";
                backdrop = "${my-images-src}/jellyfin-collections/mcu/Backdrop.jpg";
              };
            }

            {
              list_name = "Sony's Spider-Man Universe";
              list_desc = "";
              list_id = "fantic/list/sonys-spider-man-universe";
              images = {
                primary = "${my-images-src}/jellyfin-collections/ssu/Primary.png";
                backdrop = "${my-images-src}/jellyfin-collections/ssu/Backdrop.jpg";
              };
            }

            {
              list_name = "Studio Ghibli Movies";
              list_desc = "";
              list_id = "airak/list/ghibli";
              images = {
                primary = "${my-images-src}/jellyfin-collections/ghibli/Primary.jpg";
              };
            }

            {
              list_name = "MonsterVerse Collection";
              list_desc = "";
              list_id = "fantic/list/monsterverse";
              images = {
                primary = "${my-images-src}/jellyfin-collections/monsterverse/Primary.jpg";
                backdrop = "${my-images-src}/jellyfin-collections/monsterverse/Backdrop.png";
                thumb = "${my-images-src}/jellyfin-collections/monsterverse/Thumb.jpg";
              };
            }

            {
              list_name = "Unbreakable Trilogy";
              list_id = "youk/list/split";
              images = {
                primary = "${my-images-src}/jellyfin-collections/unbreakable/Primary.jpg";
              };
            }

            {
              list_name = "DCEU Collection";
              list_id = "fantic/list/dceu";
              list_desc = "";
              images = {
                primary = "${my-images-src}/jellyfin-collections/dceu/Primary.jpg";
                backdrop = "${my-images-src}/jellyfin-collections/dceu/Backdrop.jpeg";
              };
            }

            {
              list_name = "The Conjuring Universe";
              list_id = "sharpratings/list/conjuring-universe";
              list_desc = "";
              images = {
                primary = "${my-images-src}/jellyfin-collections/conjuring/Primary.jpg";
                backdrop = "${my-images-src}/jellyfin-collections/conjuring/Backdrop.jpg";
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
