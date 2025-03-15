{
  config,
  pkgs,
  ...
}: {
  systemd.services.homepage-dashboard.environment.HOMEPAGE_ALLOWED_HOSTS = "lan.nelim.org";

  services.homepage-dashboard = {
    enable = true;

    package = pkgs.selfPackages.homepage;

    listenPort = 3020;

    environmentFile = config.sops.secrets.homepage.path;

    settings = {
      title = "bruh";
      theme = "dark";
      color = "gray";
      target = "_self";

      layout.video = {
        style = "columns";
        row = 4;
        # columns = 2;
      };
    };

    widgets = [
      {
        resources = {
          cpu = true;
          memory = true;
          disk = "/";
        };
      }
      {
        search = {
          provider = "duckduckgo";
          target = "_blank";
        };
      }
    ];

    services = [
      #####################################################
      ##  PUBLIC
      #####################################################
      {
        public = [
          {
            jellyfin = rec {
              href = "https://jelly.nelim.org";
              icon = "jellyfin.png";
              description = "ourflix";
              widget = {
                type = "jellyfin";
                url = href;
                key = "{{HOMEPAGE_VAR_JELLY_API}}";
              };
            };
          }
          {
            accounts = {
              href = "https://jelly.nelim.org/accounts";
              icon = "jellyfin.png";
              description = "manage jellyfin users";
            };
          }
          {
            jellystat = {
              href = "https://lan.nelim.org/jellystat";
              icon = "jellyfin.png";
              description = "view jellyfin stats";
            };
          }
          {
            jellyseerr = rec {
              href = "https://seerr.nelim.org";
              icon = "jellyseerr.png";
              description = "request handler";
              widget = {
                type = "jellyseerr";
                url = href;
                key = "{{HOMEPAGE_VAR_SEERR_API}}";
              };
            };
          }
          {
            forgejo = {
              href = "https://git.nelim.org";
              icon = "forgejo.png";
              description = "git";
            };
          }
          {
            immich = rec {
              href = "https://photos.nelim.org";
              icon = "immich.png";
              description = "gphotos replacement";
              widget = {
                type = "immich";
                url = href;
                key = "{{HOMEPAGE_VAR_IMMICH_API}}";
                version = 2;
              };
            };
          }
          {
            gameyfin = {
              href = "https://games.nelim.org";
              description = "steam (tm)";
            };
          }
          {
            nextcloud = rec {
              href = "https://cloud.nelim.org";
              icon = "nextcloud.png";
              description = "PDrive";
              widget = {
                type = "nextcloud";
                url = href;
                username = "mathis";
                password = "{{HOMEPAGE_VAR_CLOUD_PASS}}";
              };
            };
          }
          {
            "public vaultwarden" = {
              href = "https://vault.nelim.org";
              icon = "bitwarden.png";
              description = "password manager";
            };
          }
        ];
      }
      #####################################################
      ##  VIDEO AUTOMATION
      #####################################################
      {
        "video automation" = [
          {
            qbit = rec {
              href = "https://lan.nelim.org/qbt";
              icon = "qbittorrent.png";
              description = "torrent client";
              widget = {
                type = "qbittorrent";
                url = href;
                username = "admin";
                password = "{{HOMEPAGE_VAR_QBIT_PASS}}";
              };
            };
          }
          {
            sonarr = rec {
              href = "https://lan.nelim.org/sonarr";
              icon = "sonarr.png";
              description = "fetches tv shows";
              widget = {
                type = "sonarr";
                url = href;
                key = "{{HOMEPAGE_VAR_SONARR_API}}";
              };
            };
          }
          {
            radarr = rec {
              href = "https://lan.nelim.org/radarr";
              icon = "radarr.png";
              description = "fetches movies";
              widget = {
                type = "radarr";
                url = href;
                key = "{{HOMEPAGE_VAR_RADARR_API}}";
              };
            };
          }
          {
            bazarr = rec {
              href = "https://lan.nelim.org/bazarr";
              icon = "bazarr.png";
              description = "fetches subs";
              widget = {
                type = "bazarr";
                url = href;
                key = "{{HOMEPAGE_VAR_BAZARR_API}}";
              };
            };
          }
          {
            prowlarr = rec {
              href = "https://lan.nelim.org/prowlarr";
              icon = "prowlarr.png";
              description = "fetches tracker queries";
              widget = {
                type = "prowlarr";
                url = href;
                key = "{{HOMEPAGE_VAR_PROWLARR_API}}";
              };
            };
          }
          {
            joal = {
              href = "https://joal.nelim.org";
              icon = "joal.png";
              description = "boosts YGGTorrent ratio";
            };
          }
        ];
      }
      #####################################################
      ##  MISC PROJECTS
      #####################################################
      {
        "misc projects" = [
          {
            freshrss = {
              href = "https://rss.nelim.org";
              icon = "freshrss.png";
              description = "rss client";
            };
          }
          {
            rss-bridge = {
              href = "https://bridge.nelim.org";
              icon = "rss-bridge.png";
              description = "make rss feeds from anything";
            };
          }
        ];
      }
      #####################################################
      ##  MANAGEMENT
      #####################################################
      {
        management = [
          {
            cloudflare = {
              href = "https://dash.cloudflare.com/3152abbe78daf6d91c57b6fcc424f958/nelim.org/dns";
              icon = "cloudflare.png";
              description = "dns to the world";
            };
          }
          {
            vaultwarden = {
              href = "https://lan.nelim.org/vault";
              icon = "bitwarden.png";
              description = "password manager";
            };
          }
          {
            wireguard = {
              href = "https://wg.nelim.org";
              icon = "wireguard.png";
              description = "wireguard gui";
            };
          }
          {
            survie = {
              icon = "minecraft.png";
              description = "minecwaf";
              widget = {
                type = "minecraft";
                url = "udp://mc.nelim.org";
              };
            };
          }
          {
            creative = {
              icon = "minecraft.png";
              description = "minecwaf";
              widget = {
                type = "minecraft";
                url = "udp://cv.nelim.org";
              };
            };
          }
          {
            modded = {
              icon = "minecraft.png";
              description = "minecwaf";
              widget = {
                type = "minecraft";
                url = "udp://mc2.nelim.org";
              };
            };
          }
        ];
      }
    ];
  };
}
