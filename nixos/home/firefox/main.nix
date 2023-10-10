{ config, pkgs, ... }: let
  firefox-addons = pkgs.recurseIntoAttrs (pkgs.callPackage ./addons { });
  sound-volume = firefox-addons."600-sound-volume";

  firefox-gx = pkgs.callPackage ./firefox-gx.nix { };
in
{
  home.file = {
    ".mozilla/firefox/matt/chrome/components".source = "${firefox-gx}/chrome/components";
    ".mozilla/firefox/matt/chrome/icons".source      = "${firefox-gx}/chrome/icons";
    ".mozilla/firefox/matt/chrome/images".source     = "${firefox-gx}/chrome/images";
  };

  programs.firefox = {
    enable = true;
    profiles.matt = {
      isDefault = true;
      id = 0;

      userChrome = ''
        ${builtins.readFile "${firefox-gx}/chrome/userChrome.css"}
        ${builtins.readFile ./custom.css}
      '';
      userContent = builtins.readFile "${firefox-gx}/chrome/userContent.css";
      extraConfig = builtins.readFile "${firefox-gx}/user.js";

      settings = {
        # Open previous windows and tabs
        "browser.startup.page" = 3;

        # Prefs
        "layout.css.devPixelsPerPx" = 1.15;
        "browser.tabs.firefox-view" = false;
        "browser.search.widget.inNavBar" = true;
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.toolbars.bookmarks.showInPrivateBrowsing" = true;

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
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
            definedAliases = [ "@np" ];
          };

          "NixOS Wiki" = {
            urls = [{ template =
              "https://nixos.wiki/index.php?search={searchTerms}";
            }];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@nw" ];
          };

          "MyNixos" = {
            urls = [{ template =
              "https://mynixos.com/search?q={searchTerms}";
            }];
            iconUpdateURL = "https://mynixos.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@mn" ];
          };

          "Firefox Add-ons" = {
            urls = [{ template =
              "https://addons.mozilla.org/en-US/firefox/search/?q={searchTerms}";
            }];
            iconUpdateURL = "https://addons.mozilla.org/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@fa" ];
          };

          "ProtonDB" = {
            urls = [{ template =
              "https://www.protondb.com/search?q={searchTerms}";
            }];
            iconUpdateURL = "https://www.protondb.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@pdb" ];
          };

          "YouTube" = {
            urls = [{ template =
              "https://www.youtube.com/results?search_query={searchTerms}";
            }];
            iconUpdateURL = "https://www.youtube.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@yt" "@youtube" ];
          };

          "Bing".metaData.hidden = true;
          "Google".metaData.hidden = true;
          "eBay".metaData.hidden = true;
        };
        order = [
          "DuckDuckGo"
          "MyNixos"
          "NixOS Wiki"
          "Nix Packages"
          "Wikipedia (en)"
          "YouTube"
          "Firefox Add-ons"
          "ProtonDB"
          "Amazon.ca"
        ];
      };

      extensions = with config.nur.repos;
      (with bandithedoge.firefoxAddons; [
        sponsorblock
        stylus
        #tridactyl
        ublock-origin
      ]) ++

      (with rycee.firefox-addons; [
        bitwarden
        darkreader
        floccus
        istilldontcareaboutcookies
        image-search-options
        return-youtube-dislikes
        undoclosetabbutton
      ]) ++

      (with firefox-addons; [
        sound-volume
        google-container
        checkmarks-web-ext
        opera-gx-witchcraft-purple
      ]);
    };
  };
}
