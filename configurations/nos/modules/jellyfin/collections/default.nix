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
        local = {
          enabled = true;
          clear_collection = true;
          list_ids = [
            {
              list_name = "Legacy Marvel Collection";
              list_id = "legacy-marvel";
              images = {
                primary = "${my-images-src}/jellyfin-collections/legacy-marvel/Primary.png";
                backdrop = "${my-images-src}/jellyfin-collections/legacy-marvel/Backdrop.jpg";
              };

              items = [
                # Movies
                {
                  title = "Howard the Duck";
                  imdb_id = "tt0091225";
                  media_type = "movie";
                  release_year = 1986;
                }
                {
                  title = "Daredevil";
                  imdb_id = "tt0287978";
                  media_type = "movie";
                  release_year = 2003;
                }
                {
                  title = "The Punisher";
                  imdb_id = "tt0330793";
                  media_type = "movie";
                  release_year = 2004;
                }
                {
                  title = "Elektra";
                  imdb_id = "tt0357277";
                  media_type = "movie";
                  release_year = 2005;
                }
                {
                  title = "Fantastic Four";
                  imdb_id = "tt1502712";
                  media_type = "movie";
                  release_year = 2015;
                }

                # Collections
                {
                  title = "Blade Collection";
                  tmdb_id = "735";
                }
                {
                  title = "Fantastic Four Collection";
                  tmdb_id = "9744";
                }
                {
                  title = "Ghost Rider Collection";
                  tmdb_id = "90306";
                }
              ];
            }

            {
              list_name = "Netflix's Marvel Defenders";
              list_id = "marvel-defenders";
              list_type = "playlist";

              images = {
                primary = "${my-images-src}/jellyfin-collections/marvel-defenders/Primary.jpg";
                backdrop = "${my-images-src}/jellyfin-collections/marvel-defenders/Backdrop.jpg";
              };

              items = [
                {
                  title = "Season 1";
                  series = "Marvel's Daredevil";
                  media_type = "tvSeries";
                  tvdb_id = "586321";
                }
                {
                  title = "Season 1";
                  series = "Marvel's Jessica Jones";
                  media_type = "tvSeries";
                  tvdb_id = "635536";
                }
                {
                  title = "Season 2";
                  series = "Marvel's Daredevil";
                  media_type = "tvSeries";
                  tvdb_id = "651300";
                }
                {
                  title = "Season 1";
                  series = "Marvel's Luke Cage";
                  media_type = "tvSeries";
                  tvdb_id = "659707";
                }
                {
                  title = "Season 1";
                  series = "Marvel's Iron Fist";
                  media_type = "tvSeries";
                  tvdb_id = "683460";
                }
                {
                  title = "Season 1";
                  series = "Marvel's The Defenders";
                  media_type = "tvSeries";
                  tvdb_id = "706739";
                }
                {
                  title = "Season 1";
                  series = "Marvel's The Punisher";
                  media_type = "tvSeries";
                  tvdb_id = "727172";
                }
                {
                  title = "Season 2";
                  series = "Marvel's Jessica Jones";
                  media_type = "tvSeries";
                  tvdb_id = "741219";
                }
                {
                  title = "Season 2";
                  series = "Marvel's Luke Cage";
                  media_type = "tvSeries";
                  tvdb_id = "755153";
                }
                {
                  title = "Season 2";
                  series = "Marvel's Iron Fist";
                  media_type = "tvSeries";
                  tvdb_id = "772348";
                }
                {
                  title = "Season 3";
                  series = "Marvel's Daredevil";
                  media_type = "tvSeries";
                  tvdb_id = "778668";
                }
                {
                  title = "Season 2";
                  series = "Marvel's The Punisher";
                  media_type = "tvSeries";
                  tvdb_id = "791784";
                }
                {
                  title = "Season 3";
                  series = "Marvel's Jessica Jones";
                  media_type = "tvSeries";
                  tvdb_id = "812668";
                }
              ];
            }
          ];
        };

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
              items = [
                {
                  title = "Marvel One-Shot: The Consultant";
                  imdb_id = "tt2011118";
                  release_year = 2011;
                }
                {
                  title = "Marvel One-Shot: A Funny Thing Happened on the Way to Thor's Hammer";
                  imdb_id = "tt2011109";
                  release_year = 2011;
                }
                {
                  title = "Marvel One-Shot: Item 47";
                  imdb_id = "tt2247732";
                  release_year = 2012;
                }
                {
                  title = "Marvel One-Shot: Agent Carter";
                  imdb_id = "tt3067038";
                  release_year = 2013;
                }
                {
                  title = "Marvel One-Shot: All Hail the King";
                  imdb_id = "tt3438640";
                  release_year = 2014;
                }
                {
                  title = "Team Thor";
                  imdb_id = "tt6016776";
                  release_year = 2016;
                }
                {
                  title = "Team Thor: Part 2";
                  imdb_id = "tt6599818";
                  release_year = 2017;
                }
                {
                  title = "Team Darryl";
                  imdb_id = "tt8023090";
                  release_year = 2018;
                }
              ];
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
