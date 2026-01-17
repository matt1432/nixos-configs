self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.scopedPackages) firefoxAddons;

  inherit (builtins) attrValues;
  inherit (lib) attrsToList mkIf mkOption optionalAttrs optionals singleton types;

  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  mainProfile = "dev-edition-default";
  cfg = config.programs.firefox;

  custom-css = pkgs.callPackage ./custom-css {};
in {
  options.programs.firefox.enableCustomConf = mkOption {
    type = types.bool;
    default = false;
  };

  config = mkIf cfg.enableCustomConf {
    programs.firefox = {
      enable = true;

      package = pkgs.firefox-devedition;

      profiles.${mainProfile} = {
        isDefault = true;
        id = 0;

        userChrome = ''
          @import url("file://${custom-css}");
        '';

        settings =
          {
            # Developer Edition Settings
            "xpinstall.signatures.required" = false;
            "extensions.experiments.enabled" = true;

            # Use the normal file picker
            "widget.use-xdg-desktop-portal.file-picker" = 0;

            # Open previous windows and tabs
            "browser.startup.page" = 3;

            # Prefs
            "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
            "apz.overscroll.enabled" = false;
            "browser.search.widget.inNavBar" = true;
            "browser.toolbars.bookmarks.visibility" = "always";
            "browser.toolbars.bookmarks.showInPrivateBrowsing" = true;
            "ui.key.menuAccessKey" = 0;
            "findbar.highlightAll" = true;
            "browser.tabs.groups.enabled" = true;

            # Enable devtools
            "devtools.chrome.enabled" = true;
            "devtools.debugger.remote-enabled" = true;

            # remove telemetry
            "datareporting.healthreport.uploadEnabled" = false;
            "datareporting.healthreport.infoURL" = "";
            "datareporting.policy.dataSubmissionEnabled" = false;
            "datareporting.usage.uploadEnabled" = false;
            "dom.security.https_only_mode" = true;

            # remove first run and warning stuff
            "datareporting.policy.firstRunURL" = "";
            "extensions.autoDisableScopes" = 0;
            "browser.aboutwelcome.enabled" = false;
            "browser.aboutConfig.showWarning" = false;

            # Disable firefox autofill
            "signon.rememberSignons" = false;
            "extensions.formautofill.addresses.enabled" = false;
            "extensions.formautofill.creditCards.enabled" = false;

            # remove "New Tab" stuff
            "extensions.pocket.enabled" = false;
            "services.sync.prefs.sync.browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
            "browser.newtabpage.activity-stream.feeds.system.topstories" = false;
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;

            # Firefox-gx user.js
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "svg.context-properties.content.enabled" = true;
            "layout.css.color-mix.enabled" = true;
            "browser.tabs.delayHidingAudioPlayingIconMS" = 0;
            "layout.css.backdrop-filter.enabled" = true;
            "browser.newtabpage.activity-stream.improvesearch.handoffToAwesomebar" = false;
            "browser.newtabpage.activity-stream.newtabWallpapers.enabled" = true;
            "browser.newtabpage.activity-stream.newtabWallpapers.v2.enabled" = true;

            # To activate container tabs without any extension
            "privacy.userContext.enabled" = true;
            "privacy.userContext.ui.enabled" = true;
            "privacy.userContext.longPressBehavior" = 2;
          }
          // optionalAttrs (!isDarwin) {
            "layout.css.devPixelsPerPx" = 1.12;
          }
          // optionalAttrs isDarwin {
            "ui.key.accelKey" = 17;
            "ui.key.textcontrol.prefer_native_key_bindings_over_builtin_shortcut_key_definitions" = false;
            "ui.key.menuAccessKey" = 0;
            "ui.key.menuAccessKeyFocuses" = false;
          };

        search = {
          default =
            if isDarwin
            then "google"
            else "whoogle";
          force = true;

          engines = {
            whoogle = {
              name = "Whoogle Search";
              urls = singleton {
                template = "https://search.nelim.org/search";
                params = attrsToList {
                  "q" = "{searchTerms}";
                };
              };
              icon = "https://search.nelim.org/favicon.ico";
              definedAliases = ["@s"];
            };

            code = {
              name = "Github Search Code";
              urls = singleton {
                template = "https://github.com/search";
                params = attrsToList {
                  "type" = "code";
                  "q" = "NOT is:fork {searchTerms}";
                };
              };
              icon = "https://icon.horse/icon/github.com";
              definedAliases = ["@gs"];
            };

            nixcode = {
              name = "Github Nix Code";
              urls = singleton {
                template = "https://github.com/search";
                params = attrsToList {
                  "type" = "code";
                  "q" = "lang:Nix NOT is:fork {searchTerms}";
                };
              };
              icon = "https://icon.horse/icon/github.com";
              definedAliases = ["@gn"];
            };

            nixpkgs = {
              name = "Nixpkgs";
              urls = singleton {
                template = "https://github.com/search";
                params = attrsToList {
                  "type" = "code";
                  "q" = "repo:NixOS/nixpkgs {searchTerms}";
                };
              };
              icon = "https://icon.horse/icon/github.com";
              definedAliases = ["@pkgs"];
            };

            nixwiki = {
              name = "NixOS Wiki";
              urls = singleton {
                template = "https://wiki.nixos.org/w/index.php";
                params = attrsToList {
                  "search" = "{searchTerms}";
                };
              };
              icon = "https://wiki.nixos.org/favicon.ico";
              definedAliases = ["@nw"];
            };

            mynixos = {
              name = "MyNixos";
              urls = singleton {
                template = "https://mynixos.com/search";
                params = attrsToList {
                  "q" = "{searchTerms}";
                };
              };
              icon = "https://mynixos.com/favicon.ico";
              definedAliases = ["@mn"];
            };

            noogle = {
              name = "Noogle";
              urls = singleton {
                template = "https://noogle.dev/q";
                params = attrsToList {
                  "term" = "{searchTerms}";
                };
              };
              icon = "https://noogle.dev/favicon.ico";
              definedAliases = ["@ng"];
            };

            extensions = {
              name = "Firefox Add-ons";
              urls = singleton {
                template = "https://addons.mozilla.org/en-US/firefox/search";
                params = attrsToList {
                  "q" = "{searchTerms}";
                };
              };
              icon = "https://addons.mozilla.org/favicon.ico";
              definedAliases = ["@fa"];
            };

            protondb = {
              name = "ProtonDB";
              urls = singleton {
                template = "https://www.protondb.com/search";
                params = attrsToList {
                  "q" = "{searchTerms}";
                };
              };
              icon = "https://www.protondb.com/favicon.ico";
              definedAliases = ["@pdb"];
            };

            youtube = {
              name = "YouTube";
              urls = singleton {
                template = "https://www.youtube.com/results";
                params = attrsToList {
                  "search_query" = "{searchTerms}";
                };
              };
              icon = "https://www.youtube.com/favicon.ico";
              definedAliases = ["@yt" "@youtube"];
            };

            bing.metaData.hidden = true;
            google.metaData.hidden = !isDarwin;
            ebay.metaData.hidden = true;
          };

          order =
            optionals isDarwin ["google"]
            ++ [
              "whoogle"
              "ddg"
              "mynixos"
              "nixwiki"
              "code"
              "nixcode"
              "nixpkgs"
              "noogle"
              "wikipedia"
              "youtube"
              "extensions"
              "protondb"
            ];
        };

        extensions.packages = attrValues ({
            inherit
              (firefoxAddons)
              darkreader
              image-search-options
              istilldontcareaboutcookies
              sound-volume
              stylus
              tampermonkey
              ublock-origin
              undoclosetabbutton
              ;
          }
          // optionalAttrs (!isDarwin) {
            inherit
              (firefoxAddons)
              bitwarden
              floccus
              return-youtube-dislikes
              sponsorblock
              ;
          });
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
