{
  config,
  jellarr,
  ...
}: let
  inherit
    (config.sops.secrets)
    /*
    jellarr-api-key
    */
    jellarr-env
    ;
in {
  imports = [jellarr.nixosModules.default];

  services.jellarr = {
    enable = true;
    environmentFile = jellarr-env.path;

    # FIXME: https://github.com/venkyr77/jellarr/issues/35
    /*
    bootstrap = {
      enable = true;
      apiKeyFile = jellarr-api-key.path;
    };
    */

    config = {
      version = 1;

      base_url = "https://jelly.nelim.org";

      branding = {
        loginDisclaimer = "";
        splashscreenEnabled = false;

        customCss = let
          importFile = file: "@import url('https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/${file}.css');";
        in
          # css
          ''
            /* Base theme */
            ${importFile "base"}
            ${importFile "accentlist"}
            ${importFile "fixes"}

            ${importFile "type/dark_withaccent"}

            ${importFile "rounding"}
            ${importFile "progress/floating"}
            ${importFile "titlepage/title_banner-logo"}
            ${importFile "header/header_transparent"}
            ${importFile "login/login_frame"}
            ${importFile "fields/fields_border"}
            ${importFile "cornerindicator/indicator_floating"}

            /* Style backdrop */
            .backdropImage {
                filter: blur(18px) saturate(120%) contrast(120%) brightness(40%);
            }

            /* Fix Jellyfin's st**pid skip-intro placement */
            .skip-button {
                position: fixed;
                bottom: 18%;
                right: 16%;
            }

            /* Custom Settings */
            :root {--accent: 145,75,245;}
            :root {--rounding: 12px;}

            /* https://github.com/CTalvio/Ultrachromic/issues/79 */
            .skinHeader {
                color: rgba(var(--accent), 0.8);;
            }
            .countIndicator,
            .fullSyncIndicator,
            .mediaSourceIndicator,
            .playedIndicator {
                background-color: rgba(var(--accent), 0.8);
            }

            /* Editor's Choice */
            .splide__track.splide__track--loop.splide__track--ltr.splide__track--draggable {
                border-radius: var(--rounding);
            }
          '';
      };

      encoding = {
        allowAv1Encoding = false;
        allowHevcEncoding = false;
        enableDecodingColorDepth10Hevc = true;
        enableDecodingColorDepth10HevcRext = false;
        enableDecodingColorDepth10Vp9 = true;
        enableDecodingColorDepth12HevcRext = false;

        enableHardwareEncoding = true;
        hardwareAccelerationType = "nvenc";
        hardwareDecodingCodecs = [
          "h264"
          "hevc"
          "mpeg2video"
          "vc1"
          "vp8"
          "vp9"
          "av1"
        ];
      };

      system = {
        # FIXME: not supported yet with Jellarr?
        /*
        serverName = "Jelly";
        quickConnectAvailable = false;
        isStartupWizardCompleted = true;

        enableGroupingMoviesIntoCollections = true;
        enableGroupingShowsIntoCollections = true;
        enableExternalContentInSuggestions = false;

        enableSlowResponseWarning = false;
        */

        enableMetrics = false;

        trickplayOptions = {
          enableHwAcceleration = false;
          enableHwEncoding = false;
        };

        pluginRepositories = [
          {
            enabled = true;
            name = "Jellyfin Stable";
            url = "https://repo.jellyfin.org/releases/plugin/manifest-stable.json";
          }
          {
            enabled = true;
            name = "Intro Skipper";
            url = "https://manifest.intro-skipper.org/manifest.json";
          }
          {
            enabled = true;
            name = "Merge Versions Plugin";
            url = "https://raw.githubusercontent.com/danieladov/JellyfinPluginManifest/master/manifest.json";
          }
          {
            enabled = true;
            name = "Meilisearch";
            url = "https://raw.githubusercontent.com/arnesacnussem/jellyfin-plugin-meilisearch/refs/heads/master/manifest.json";
          }
          {
            enabled = true;
            name = "Air Times";
            url = "https://raw.githubusercontent.com/apteryxxyz/jellyfin-plugin-airtimes/main/manifest.json";
          }
          {
            enabled = true;
            name = "InPlayerEpisodePreview";
            url = "https://raw.githubusercontent.com/Namo2/InPlayerEpisodePreview/master/manifest.json";
          }
          {
            enabled = true;
            name = "Streamyfin";
            url = "https://raw.githubusercontent.com/streamyfin/jellyfin-plugin-streamyfin/main/manifest.json";
          }
          {
            enabled = true;
            name = "Editor's Choice";
            url = "https://github.com/lachlandcp/jellyfin-editors-choice-plugin/raw/main/manifest.json";
          }
          {
            enabled = true;
            name = "JS Injector";
            url = "https://raw.githubusercontent.com/n00bcodr/jellyfin-plugins/main/10.11/manifest.json ";
          }
        ];
      };

      plugins = [
        {
          name = "Air Times";
          configuration = {};
        }

        {
          name = "EditorsChoice";
          configuration = {
            Mode = "NEW";
            NewTimeLimit = "1month";

            EditorUserId = "d36f794e07e9451fa62ff76243f47a65";
            Heading = "New on Jellyfin / Recently Updated";

            DoScriptInject = true;
            FileTransformation = false;
            HideOnTvLayout = false;

            MinimumCriticRating = 8;
            MinimumRating = 8;

            ShowDescription = true;
            ShowPlayed = true;
            ShowRandomMedia = false;
            ShowRating = true;
          };
        }

        {
          name = "InPlayerEpisodePreview";
          configuration = {};
        }

        {
          name = "Intro Skipper";
          configuration = {
            AutoDetectIntros = true;
            UpdateMediaSegments = true;
            CacheFingerprints = true;

            ScanCommercial = true;
            ScanCredits = true;
            ScanIntroduction = true;
            ScanPreview = true;
            ScanRecap = true;

            FileTransformationPluginEnabled = false;
            UseFileTransformationPlugin = false;
          };
        }

        {
          name = "JavaScript Injector";
          configuration = let
            mkInjectRemoteScript = url:
            # javascript
            ''
              const script = document.createElement('script');
              script.src = `${url}`;
              script.async = true;
              document.head.appendChild(script);
            '';
          in {
            CustomJavaScripts = [
              {
                Name = "Kefin Tweaks";
                Enabled = true;
                RequiresAuthentication = false;
                Script = mkInjectRemoteScript "https://cdn.jsdelivr.net/gh/ranaldsgift/KefinTweaks@latest/kefinTweaks-plugin.js";
              }
              {
                Name = "jf-avatars";
                Enabled = true;
                RequiresAuthentication = false;
                Script = mkInjectRemoteScript "https://github.com/kalibrado/jf-avatars/releases/latest/download/main.js";
              }
            ];
          };
        }

        {
          name = "Meilisearch";
          configuration = {
            Url = "http://127.0.0.1:7700";
            ApiKey = "1234";
            IndexName = "";

            AttributesToSearchOn = ["name" "artists" "albumArtists" "originalTitle" "productionYear" "seriesName" "genres" "tags" "studios" "overview" "path"];
            Debug = false;
            FallbackToJellyfin = true;
          };
        }

        {
          name = "Merge Versions";
          configuration = {};
        }

        {
          name = "OMDb";
          configuration = {
            CastAndCrew = false;
          };
        }

        {
          name = "Streamyfin";
          configuration = {
            Config = {
              settings = {
                jellyseerrServerUrl = {
                  locked = true;
                  value = "https://seerr.nelim.org";
                };
                rememberAudioSelections = {
                  locked = false;
                  value = true;
                };
                rememberSubtitleSelections = {
                  locked = false;
                  value = true;
                };
              };
            };
          };
        }

        {
          name = "TheTVDB";
          configuration = {};
        }

        {
          name = "TMDb";
          configuration = {};
        }
      ];
    };
  };
}
