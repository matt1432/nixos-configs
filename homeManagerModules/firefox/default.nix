self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.scopedPackages.${pkgs.system}) firefoxAddons;

  inherit (lib) attrsToList attrValues mkIf mkOption singleton types;

  cfg = config.programs.firefox;

  rounding = (config.wayland.windowManager.hyprland.settings.decoration.rounding or 2) - 2;

  firefox-gx = pkgs.callPackage ./firefox-gx {inherit self;};
  custom-css = pkgs.callPackage ./custom-css {inherit rounding firefox-gx;};
in {
  options.programs.firefox.enableCustomConf = mkOption {
    type = types.bool;
    default = false;
  };

  config = mkIf cfg.enableCustomConf {
    home.file = {
      ".mozilla/firefox/matt/chrome/userContent.css".source = "${firefox-gx}/chrome/userContent.css";
      ".mozilla/firefox/matt/chrome/components".source = "${firefox-gx}/chrome/components";
      ".mozilla/firefox/matt/chrome/images".source = "${firefox-gx}/chrome/images";
      ".mozilla/firefox/matt/chrome/icons".source = "${firefox-gx}/chrome/icons";
    };

    programs.firefox = {
      enable = true;

      profiles.matt = {
        isDefault = true;
        id = 0;

        userChrome = ''
          @import url("file://${firefox-gx}/chrome/userChrome.css");
          @import url("file://${custom-css}");
        '';

        settings = {
          # Theme
          "firefoxgx.tab-shapes" = true;
          "firefoxgx.left-sidebar" = true;
          "userChrome.tab.bottom_rounded_corner" = true;
          "userChrome.tab.bottom_rounded_corner.wave" = false;
          "userChrome.tab.bottom_rounded_corner.australis" = true;

          # Use the normal file picker
          "widget.use-xdg-desktop-portal.file-picker" = 0;

          # Firefox-gx user.js
          /*
          Default rules
          */
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
          "layout.css.color-mix.enabled" = true;
          "browser.tabs.delayHidingAudioPlayingIconMS" = 0;
          "layout.css.backdrop-filter.enabled" = true;
          "browser.newtabpage.activity-stream.improvesearch.handoffToAwesomebar" = false;
          "browser.newtabpage.activity-stream.newtabWallpapers.enabled" = true;

          /*
          To active container tabs without any extension
          */
          "privacy.userContext.enabled" = true;
          "privacy.userContext.ui.enabled" = true;
          "privacy.userContext.longPressBehavior" = 2;

          # Open previous windows and tabs
          "browser.startup.page" = 3;

          # Prefs
          "apz.overscroll.enabled" = false;
          "layout.css.devPixelsPerPx" = 1.12;
          "browser.search.widget.inNavBar" = true;
          "browser.toolbars.bookmarks.visibility" = "always";
          "browser.toolbars.bookmarks.showInPrivateBrowsing" = true;
          "ui.key.menuAccessKey" = 0;

          # remove telemetry
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.healthreport.infoURL" = "";
          "dom.security.https_only_mode" = true;

          # remove first run and warning stuff
          "datareporting.policy.firstRunURL" = "";
          "browser.aboutwelcome.enabled" = false;
          "browser.aboutConfig.showWarning" = false;

          # Disable firefox autofill
          "signon.rememberSignons" = false;
          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;

          # remove new tab stuff
          "extensions.pocket.enabled" = false;
          "services.sync.prefs.sync.browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.activity-stream.feeds.system.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        };

        search = {
          default = "SearXNG";
          force = true;
          engines = {
            "SearXNG" = {
              urls = singleton {
                template = "https://search.nelim.org/search";
                params = attrsToList {
                  "q" = "{searchTerms}";
                };
              };
              iconMapObj."16" = "https://search.nelim.org/favicon.ico";
              definedAliases = ["@s"];
            };

            "Github Search Code" = {
              urls = singleton {
                template = "https://github.com/search";
                params = attrsToList {
                  "type" = "code";
                  "q" = "NOT is:fork {searchTerms}";
                };
              };
              iconMapObj."16" = "https://icon.horse/icon/github.com";
              definedAliases = ["@gs"];
            };

            "Github Nix Code" = {
              urls = singleton {
                template = "https://github.com/search";
                params = attrsToList {
                  "type" = "code";
                  "q" = "lang:Nix NOT is:fork {searchTerms}";
                };
              };
              iconMapObj."16" = "https://icon.horse/icon/github.com";
              definedAliases = ["@gn"];
            };

            "Nixpkgs" = {
              urls = singleton {
                template = "https://github.com/search";
                params = attrsToList {
                  "type" = "code";
                  "q" = "repo:NixOS/nixpkgs {searchTerms}";
                };
              };
              iconMapObj."16" = "https://icon.horse/icon/github.com";
              definedAliases = ["@pkgs"];
            };

            "NixOS Wiki" = {
              urls = singleton {
                template = "https://wiki.nixos.org/w/index.php";
                params = attrsToList {
                  "search" = "{searchTerms}";
                };
              };
              iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
              definedAliases = ["@nw"];
            };

            "MyNixos" = {
              urls = singleton {
                template = "https://mynixos.com/search";
                params = attrsToList {
                  "q" = "{searchTerms}";
                };
              };
              iconMapObj."16" = "https://mynixos.com/favicon.ico";
              definedAliases = ["@mn"];
            };

            "Noogle" = {
              urls = singleton {
                template = "https://noogle.dev/q";
                params = attrsToList {
                  "term" = "{searchTerms}";
                };
              };
              iconMapObj."16" = "https://noogle.dev/favicon.ico";
              definedAliases = ["@ng"];
            };

            "Firefox Add-ons" = {
              urls = singleton {
                template = "https://addons.mozilla.org/en-US/firefox/search";
                params = attrsToList {
                  "q" = "{searchTerms}";
                };
              };
              iconMapObj."16" = "https://addons.mozilla.org/favicon.ico";
              definedAliases = ["@fa"];
            };

            "ProtonDB" = {
              urls = singleton {
                template = "https://www.protondb.com/search";
                params = attrsToList {
                  "q" = "{searchTerms}";
                };
              };
              iconMapObj."16" = "https://www.protondb.com/favicon.ico";
              definedAliases = ["@pdb"];
            };

            "YouTube" = {
              urls = singleton {
                template = "https://www.youtube.com/results";
                params = attrsToList {
                  "search_query" = "{searchTerms}";
                };
              };
              iconMapObj."16" = "https://www.youtube.com/favicon.ico";
              definedAliases = ["@yt" "@youtube"];
            };

            "Bing".metaData.hidden = true;
            "Google".metaData.hidden = true;
            "eBay".metaData.hidden = true;
          };

          order = [
            "SearXNG"
            "DuckDuckGo"
            "MyNixos"
            "NixOS Wiki"
            "Github Search Code"
            "Github Nix Code"
            "Nixpkgs"
            "Noogle"
            "Wikipedia (en)"
            "YouTube"
            "Firefox Add-ons"
            "ProtonDB"
            "Amazon.ca"
          ];
        };

        extensions.packages = attrValues {
          inherit
            (firefoxAddons)
            auto-refresh-page
            bitwarden
            checkmarks-web-ext
            darkreader
            floccus
            google-container
            image-search-options
            istilldontcareaboutcookies
            opera-gx-witchcraft-purple
            return-youtube-dislikes
            seventv
            sponsorblock
            sound-volume
            stylus
            ttv-lol-pro
            ublock-origin
            undoclosetabbutton
            ;
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
