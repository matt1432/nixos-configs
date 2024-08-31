self: {
  osConfig,
  pkgs,
  ...
}: let
  inherit (osConfig.networking) hostName;

  inherit (self.legacyPackages.${pkgs.system}) firefoxAddons;

  firefox-gx = pkgs.callPackage ./gx-theme.nix {
    inherit (self.inputs) firefox-gx-src;
    inherit (import "${self}/lib" {}) mkVersion;
  };
in {
  config = {
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
          ${import ./custom-css.nix hostName}
        '';

        settings = {
          # Theme
          "firefoxgx.tab-shapes" = true;
          "firefoxgx.left-sidebar" = true;
          "userChrome.tab.bottom_rounded_corner" = true;
          "userChrome.tab.bottom_rounded_corner.wave" = false;
          "userChrome.tab.bottom_rounded_corner.australis" = true;
          "widget.use-xdg-desktop-portal.file-picker" = 1;

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
          default = "DuckDuckGo";
          force = true;
          engines = {
            "Nixpkgs" = {
              urls = [
                {
                  template = "https://github.com/search?q=repo%3ANixOS%2Fnixpkgs%20{searchTerms}&type=code";
                }
              ];
              iconUpdateURL = "https://github.githubassets.com/favicons/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = ["@pkgs"];
            };

            "NixOS Wiki" = {
              urls = [
                {
                  template = "https://nixos.wiki/index.php?search={searchTerms}";
                }
              ];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = ["@nw"];
            };

            "MyNixos" = {
              urls = [
                {
                  template = "https://mynixos.com/search?q={searchTerms}";
                }
              ];
              iconUpdateURL = "https://mynixos.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = ["@mn"];
            };

            "Noogle" = {
              urls = [
                {
                  template = "https://noogle.dev/q?term={searchTerms}";
                }
              ];
              iconUpdateURL = "https://noogle.dev/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = ["@ng"];
            };

            "Firefox Add-ons" = {
              urls = [
                {
                  template = "https://addons.mozilla.org/en-US/firefox/search/?q={searchTerms}";
                }
              ];
              iconUpdateURL = "https://addons.mozilla.org/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = ["@fa"];
            };

            "ProtonDB" = {
              urls = [
                {
                  template = "https://www.protondb.com/search?q={searchTerms}";
                }
              ];
              iconUpdateURL = "https://www.protondb.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = ["@pdb"];
            };

            "YouTube" = {
              urls = [
                {
                  template = "https://www.youtube.com/results?search_query={searchTerms}";
                }
              ];
              iconUpdateURL = "https://www.youtube.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = ["@yt" "@youtube"];
            };

            "Bing".metaData.hidden = true;
            "Google".metaData.hidden = true;
            "eBay".metaData.hidden = true;
          };
          order = [
            "DuckDuckGo"
            "MyNixos"
            "NixOS Wiki"
            "Nixpkgs"
            "Noogle"
            "Wikipedia (en)"
            "YouTube"
            "Firefox Add-ons"
            "ProtonDB"
            "Amazon.ca"
          ];
        };

        extensions = builtins.attrValues {
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
