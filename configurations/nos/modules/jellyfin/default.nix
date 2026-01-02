{
  config,
  nixos-jellyfin,
  lib,
  mainUser,
  pkgs,
  ...
}: let
  inherit (lib) hasAttr optionals;

  optionalGroup = name:
    optionals
    (hasAttr name config.users.groups)
    [config.users.groups.${name}.name];
in {
  imports = [
    ./collections
    ./jfa-go.nix
    ./meilisearch.nix

    nixos-jellyfin.nixosModules.default
  ];

  users.users."jellyfin".extraGroups =
    optionalGroup mainUser
    ++ optionalGroup "input"
    ++ optionalGroup "media"
    ++ optionalGroup "render"
    ++ optionalGroup "video";

  services.jellyfin = {
    enable = true;

    ffmpegPackage = pkgs.jellyfin-ffmpeg-cuda;

    webPackage = pkgs.jellyfin-web.override {
      forceEnableBackdrops = true;
      forceDisablePreferFmp4 = true;
    };

    settings = {
      system = {
        serverName = "Jelly";
        quickConnectAvailable = false;
        isStartupWizardCompleted = true;

        enableGroupingMoviesIntoCollections = true;
        enableGroupingShowsIntoCollections = true;
        enableExternalContentInSuggestions = false;

        pluginRepositories = [
          {
            name = "Jellyfin Stable";
            url = "https://repo.jellyfin.org/releases/plugin/manifest-stable.json";
          }
          {
            name = "Intro Skipper";
            url = "https://manifest.intro-skipper.org/manifest.json";
          }
          {
            name = "Merge Versions Plugin";
            url = "https://raw.githubusercontent.com/danieladov/JellyfinPluginManifest/master/manifest.json";
          }
          {
            name = "Meilisearch";
            url = "https://raw.githubusercontent.com/arnesacnussem/jellyfin-plugin-meilisearch/refs/heads/master/manifest.json";
          }
          {
            name = "Air Times";
            url = "https://raw.githubusercontent.com/apteryxxyz/jellyfin-plugin-airtimes/main/manifest.json";
          }
          {
            name = "InPlayerEpisodePreview";
            url = "https://raw.githubusercontent.com/Namo2/InPlayerEpisodePreview/master/manifest.json";
          }
          {
            name = "Streamyfin";
            url = "https://raw.githubusercontent.com/streamyfin/jellyfin-plugin-streamyfin/main/manifest.json";
          }
          {
            name = "Editor's Choice";
            url = "https://github.com/lachlandcp/jellyfin-editors-choice-plugin/raw/main/manifest.json";
          }
          {
            name = "JS Injector";
            url = "https://raw.githubusercontent.com/n00bcodr/jellyfin-plugins/main/10.11/manifest.json ";
          }
        ];

        enableSlowResponseWarning = false;
      };

      branding = let
        importFile = file: "@import url('https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/${file}.css');";
      in {
        customCss = ''
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
          .backdropImage {filter: blur(18px) saturate(120%) contrast(120%) brightness(40%);}

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
          /* Editor's Choice */
          .splide__track.splide__track--loop.splide__track--ltr.splide__track--draggable {
              border-radius: var(--rounding);
          }
        '';
      };

      encoding = {
        hardwareAccelerationType = "nvenc";
        hardwareDecodingCodecs = [
          "h264"
          "hevc"
          "mpeg2video"
          "mpeg4"
          "vc1"
          "vp8"
          "vp9"
          "av1"
        ];
        allowHevcEncoding = false;
        enableThrottling = false;
        enableTonemapping = true;
        downMixAudioBoost = 1;
      };
    };
  };
}
