{
  config,
  jellyfin-flake,
  jellyfin-ultrachromic-src,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) hasAttr fileContents optionals;
  inherit (config.vars) mainUser;

  optionalGroup = name:
    optionals
    (hasAttr name config.users.groups)
    [config.users.groups.${name}.name];
in {
  imports = [
    ./jfa-go.nix
    ./packages.nix
    jellyfin-flake.nixosModules.default
  ];

  users.users."jellyfin".extraGroups =
    optionalGroup mainUser
    ++ optionalGroup "input"
    ++ optionalGroup "media"
    ++ optionalGroup "render";

  services = {
    jellyfin = {
      enable = true;

      settings = {
        general = {
          serverName = "Jelly";

          quickConnectAvailable = false;
          isStartupWizardCompleted = true;

          branding = let
            jellyTheme = pkgs.stdenv.mkDerivation {
              name = "Ultrachromic";
              src = jellyfin-ultrachromic-src;
              postInstall = "cp -ar $src $out";
            };

            importFile = file: fileContents "${jellyTheme}/${file}";
          in {
            customCss = ''
              /* Base theme */
              ${importFile "base.css"}
              ${importFile "accentlist.css"}
              ${importFile "fixes.css"}

              ${importFile "type/dark_withaccent.css"}

              ${importFile "rounding.css"}
              ${importFile "progress/floating.css"}
              ${importFile "titlepage/title_banner-logo.css"}
              ${importFile "header/header_transparent.css"}
              ${importFile "login/login_frame.css"}
              ${importFile "fields/fields_border.css"}
              ${importFile "cornerindicator/indicator_floating.css"}

              /* Style backdrop */
              .backdropImage {filter: blur(18px) saturate(120%) contrast(120%) brightness(40%);}

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
            '';
          };
        };

        libraries.display = {
          enableGroupingIntoCollections = true;
          enableExternalContentInSuggestions = false;
        };

        playback.transcoding = {
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
          enableThrottling = true;
          enableTonemapping = true;
          downMixAudioBoost = 1;
        };

        plugins.pluginRepositories = [
          {
            name = "Jellyfin Stable";
            url = "https://repo.jellyfin.org/releases/plugin/manifest-stable.json";
          }
          {
            name = "Intro Skipper";
            url = "https://raw.githubusercontent.com/jumoog/intro-skipper/master/manifest.json";
          }
        ];

        advanced.logs.enableSlowResponseWarning = false;
      };
    };

    nginx = {
      enable = true;
      config = fileContents ./nginx.conf;
    };
  };
}
