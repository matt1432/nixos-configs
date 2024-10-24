{
  buildFirefoxXpiAddon,
  fetchurl,
  lib,
  stdenv,
}: {
  "auto-refresh-page" = buildFirefoxXpiAddon {
    pname = "auto-refresh-page";
    version = "3.2";
    addonId = "{da35dad8-f912-4c74-8f64-c4e6e6d62610}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4064190/auto_refresh_page-3.2.xpi";
    sha256 = "e703d1031107bb440e3081b210e58ebf5a05a620683e42ce6255b66994475f8d";
    meta = with lib; {
      homepage = "https://www.hashtap.com/@refresh";
      description = "Refresh web pages automatically. Auto-refresh and page monitor with specified time intervals.";
      license = licenses.mit;
      mozPermissions = [
        "tabs"
        "storage"
        "contextMenus"
        "browsingData"
        "notifications"
        "webRequest"
        "webRequestBlocking"
        "<all_urls>"
      ];
      platforms = platforms.all;
    };
  };
  "bitwarden" = buildFirefoxXpiAddon {
    pname = "bitwarden";
    version = "2024.10.0";
    addonId = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4363548/bitwarden_password_manager-2024.10.0.xpi";
    sha256 = "9ea9428444870a74ae1999d77eb12d97a45275c85e83d6afdcbc4597fa3eccfb";
    meta = with lib; {
      homepage = "https://bitwarden.com";
      description = "At home, at work, or on the go, Bitwarden easily secures all your passwords, passkeys, and sensitive information.";
      license = licenses.gpl3;
      mozPermissions = [
        "<all_urls>"
        "*://*/*"
        "tabs"
        "contextMenus"
        "storage"
        "unlimitedStorage"
        "clipboardRead"
        "clipboardWrite"
        "idle"
        "alarms"
        "webRequest"
        "webRequestBlocking"
        "webNavigation"
        "file:///*"
        "https://lastpass.com/export.php"
      ];
      platforms = platforms.all;
    };
  };
  "checkmarks-web-ext" = buildFirefoxXpiAddon {
    pname = "checkmarks-web-ext";
    version = "1.6.1";
    addonId = "{bd97f89b-17ba-4539-9fec-06852d07f917}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3594420/checkmarks_web_ext-1.6.1.xpi";
    sha256 = "c3ccf4b302ee96c9b883c4a1f7d26395ab4e276b976cab2d65c9cd898964e4f0";
    meta = with lib; {
      homepage = "https://github.com/tanwald/checkmarks";
      description = "Checks, sorts, formats bookmarks and loads favicons.";
      license = licenses.gpl3;
      mozPermissions = [
        "<all_urls>"
        "bookmarks"
        "browsingData"
        "storage"
        "tabs"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
      ];
      platforms = platforms.all;
    };
  };
  "darkreader" = buildFirefoxXpiAddon {
    pname = "darkreader";
    version = "4.9.94";
    addonId = "addon@darkreader.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/4359254/darkreader-4.9.94.xpi";
    sha256 = "251c4e7d0a30c0cab006803600e59ab92dcc0c606429740d42677846d4c9ccd6";
    meta = with lib; {
      homepage = "https://darkreader.org/";
      description = "Dark mode for every website. Take care of your eyes, use dark theme for night and daily browsing.";
      license = licenses.mit;
      mozPermissions = [
        "alarms"
        "contextMenus"
        "storage"
        "tabs"
        "theme"
        "<all_urls>"
      ];
      platforms = platforms.all;
    };
  };
  "floccus" = buildFirefoxXpiAddon {
    pname = "floccus";
    version = "5.3.1";
    addonId = "floccus@handmadeideas.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/4367114/floccus-5.3.1.xpi";
    sha256 = "11e917118d059aced688f5ef467782b7a1326297db27ba92ff2379f72e5a43b6";
    meta = with lib; {
      homepage = "https://floccus.org";
      description = "Sync your bookmarks and tabs across browsers via Nextcloud, any WebDAV service, any Git service, via a local file, via Google Drive.";
      license = licenses.mpl20;
      mozPermissions = [
        "*://*/*"
        "alarms"
        "bookmarks"
        "storage"
        "unlimitedStorage"
        "tabs"
        "identity"
      ];
      platforms = platforms.all;
    };
  };
  "google-container" = buildFirefoxXpiAddon {
    pname = "google-container";
    version = "1.5.4";
    addonId = "@contain-google";
    url = "https://addons.mozilla.org/firefox/downloads/file/3736912/google_container-1.5.4.xpi";
    sha256 = "47a7c0e85468332a0d949928d8b74376192cde4abaa14280002b3aca4ec814d0";
    meta = with lib; {
      homepage = "https://github.com/containers-everywhere/contain-google";
      description = "THIS IS NOT AN OFFICIAL ADDON FROM MOZILLA!\nIt is a fork of the Facebook Container addon.\n\nPrevent Google from tracking you around the web. The Google Container extension helps you take control and isolate your web activity from Google.";
      license = licenses.mpl20;
      mozPermissions = [
        "<all_urls>"
        "contextualIdentities"
        "cookies"
        "management"
        "tabs"
        "webRequestBlocking"
        "webRequest"
        "storage"
      ];
      platforms = platforms.all;
    };
  };
  "image-search-options" = buildFirefoxXpiAddon {
    pname = "image-search-options";
    version = "3.0.12";
    addonId = "{4a313247-8330-4a81-948e-b79936516f78}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3059971/image_search_options-3.0.12.xpi";
    sha256 = "1fbdd8597fc32b1be11302a958ea3ba2b010edcfeb432c299637b2c58c6fd068";
    meta = with lib; {
      homepage = "http://saucenao.com/";
      description = "A customizable reverse image search tool that conveniently presents a variety of top image search engines.";
      license = licenses.mpl11;
      mozPermissions = [
        "storage"
        "contextMenus"
        "activeTab"
        "tabs"
        "<all_urls>"
      ];
      platforms = platforms.all;
    };
  };
  "istilldontcareaboutcookies" = buildFirefoxXpiAddon {
    pname = "istilldontcareaboutcookies";
    version = "1.1.4";
    addonId = "idcac-pub@guus.ninja";
    url = "https://addons.mozilla.org/firefox/downloads/file/4216095/istilldontcareaboutcookies-1.1.4.xpi";
    sha256 = "cadeb24622d3b9a2b82bf4308242fd802546b126bb9dd14e1ea66f2aa2066795";
    meta = with lib; {
      homepage = "https://github.com/OhMyGuus/I-Dont-Care-About-Cookies";
      description = "Community version of the popular extension \"I don't care about cookies\"  \n\n<a href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/d899243c3222e303a4ac90833f850da61cdf8f7779e2685f60f657254302216d/https%3A//github.com/OhMyGuus/I-Dont-Care-About-Cookies\" rel=\"nofollow\">https://github.com/OhMyGuus/I-Dont-Care-About-Cookies</a>";
      license = licenses.gpl3;
      mozPermissions = [
        "tabs"
        "storage"
        "http://*/*"
        "https://*/*"
        "notifications"
        "webRequest"
        "webRequestBlocking"
        "webNavigation"
      ];
      platforms = platforms.all;
    };
  };
  "opera-gx-witchcraft-purple" = buildFirefoxXpiAddon {
    pname = "opera-gx-witchcraft-purple";
    version = "2.0";
    addonId = "{bf197856-a3c2-4280-84c5-9b556379b706}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3522842/opera_gx_witchcraft_purple-2.0.xpi";
    sha256 = "aa3c6377b8571c42a3988de042694be70ec6a250a9aea7ae1cc262acdc9374eb";
    meta = with lib; {
      description = "inspired by Opera GX";
      license = licenses.cc-by-sa-30;
      mozPermissions = [];
      platforms = platforms.all;
    };
  };
  "return-youtube-dislikes" = buildFirefoxXpiAddon {
    pname = "return-youtube-dislikes";
    version = "3.0.0.17";
    addonId = "{762f9885-5a13-4abd-9c77-433dcd38b8fd}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4342747/return_youtube_dislikes-3.0.0.17.xpi";
    sha256 = "c9115baa653c22390089fd6f028c88b9ca9c56f25112ff13e497caba984df841";
    meta = with lib; {
      description = "Returns ability to see dislike statistics on youtube";
      license = licenses.gpl3;
      mozPermissions = [
        "activeTab"
        "*://*.youtube.com/*"
        "storage"
        "*://returnyoutubedislikeapi.com/*"
      ];
      platforms = platforms.all;
    };
  };
  "sound-volume" = buildFirefoxXpiAddon {
    pname = "sound-volume";
    version = "1.5.5";
    addonId = "{c4b582ec-4343-438c-bda2-2f691c16c262}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4219765/600_sound_volume-1.5.5.xpi";
    sha256 = "efc686d54727f29b5c796f4037f19a5d5f31f77354c9c5f8f47d8768ba24fe98";
    meta = with lib; {
      homepage = "http://resourcefulman.net/";
      description = "Up to 600% volume boost";
      license = licenses.mpl20;
      mozPermissions = [
        "<all_urls>"
        "tabs"
        "activeTab"
        "storage"
        "webRequest"
        "webRequestBlocking"
      ];
      platforms = platforms.all;
    };
  };
  "sponsorblock" = buildFirefoxXpiAddon {
    pname = "sponsorblock";
    version = "5.9.4";
    addonId = "sponsorBlocker@ajay.app";
    url = "https://addons.mozilla.org/firefox/downloads/file/4364207/sponsorblock-5.9.4.xpi";
    sha256 = "1bff70a70685caaf444b57984a26c910a456bbbcc50d24d2d58a081ba114f7a3";
    meta = with lib; {
      homepage = "https://sponsor.ajay.app";
      description = "Easily skip YouTube video sponsors. When you visit a YouTube video, the extension will check the database for reported sponsors and automatically skip known sponsors. You can also report sponsors in videos. Other browsers: https://sponsor.ajay.app";
      license = licenses.lgpl3;
      mozPermissions = [
        "storage"
        "scripting"
        "https://sponsor.ajay.app/*"
        "https://*.youtube.com/*"
        "https://www.youtube-nocookie.com/embed/*"
      ];
      platforms = platforms.all;
    };
  };
  "stylus" = buildFirefoxXpiAddon {
    pname = "stylus";
    version = "1.5.51";
    addonId = "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4338993/styl_us-1.5.51.xpi";
    sha256 = "4d7c184af2d81f40c35f33c77c4040dc4205908dbcf65e7c99fafd7d26e4814f";
    meta = with lib; {
      homepage = "https://add0n.com/stylus.html";
      description = "Redesign your favorite websites with Stylus, an actively developed and community driven userstyles manager. Easily install custom themes from popular online repositories, or create, edit, and manage your own personalized CSS stylesheets.";
      license = licenses.gpl3;
      mozPermissions = [
        "tabs"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
        "contextMenus"
        "storage"
        "unlimitedStorage"
        "alarms"
        "<all_urls>"
        "http://userstyles.org/*"
        "https://userstyles.org/*"
      ];
      platforms = platforms.all;
    };
  };
  "ttv-lol-pro" = buildFirefoxXpiAddon {
    pname = "ttv-lol-pro";
    version = "2.3.10";
    addonId = "{76ef94a4-e3d0-4c6f-961a-d38a429a332b}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4357094/ttv_lol_pro-2.3.10.xpi";
    sha256 = "b33cd0cd4e3521520ef233b21179228fdadeca168359acab4c24bbb1a166fcda";
    meta = with lib; {
      homepage = "https://github.com/younesaassila/ttv-lol-pro";
      description = "TTV LOL PRO removes most livestream ads from Twitch.";
      license = licenses.gpl3;
      mozPermissions = [
        "proxy"
        "storage"
        "webRequest"
        "webRequestBlocking"
        "https://*.live-video.net/*"
        "https://*.ttvnw.net/*"
        "https://*.twitch.tv/*"
        "https://perfprod.com/ttvlolpro/telemetry"
        "https://www.twitch.tv/*"
        "https://m.twitch.tv/*"
      ];
      platforms = platforms.all;
    };
  };
  "ublock-origin" = buildFirefoxXpiAddon {
    pname = "ublock-origin";
    version = "1.60.0";
    addonId = "uBlock0@raymondhill.net";
    url = "https://addons.mozilla.org/firefox/downloads/file/4359936/ublock_origin-1.60.0.xpi";
    sha256 = "e2cda9b2a1b0a7f6e5ef0da9f87f28df52f8560587ba2e51a3003121cfb81600";
    meta = with lib; {
      homepage = "https://github.com/gorhill/uBlock#ublock-origin";
      description = "Finally, an efficient wide-spectrum content blocker. Easy on CPU and memory.";
      license = licenses.gpl3;
      mozPermissions = [
        "alarms"
        "dns"
        "menus"
        "privacy"
        "storage"
        "tabs"
        "unlimitedStorage"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
        "<all_urls>"
        "http://*/*"
        "https://*/*"
        "file://*/*"
        "https://easylist.to/*"
        "https://*.fanboy.co.nz/*"
        "https://filterlists.com/*"
        "https://forums.lanik.us/*"
        "https://github.com/*"
        "https://*.github.io/*"
        "https://github.com/uBlockOrigin/*"
        "https://ublockorigin.github.io/*"
        "https://*.reddit.com/r/uBlockOrigin/*"
      ];
      platforms = platforms.all;
    };
  };
  "undoclosetabbutton" = buildFirefoxXpiAddon {
    pname = "undoclosetabbutton";
    version = "8.0.0";
    addonId = "{4853d046-c5a3-436b-bc36-220fd935ee1d}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4212173/undoclosetabbutton-8.0.0.xpi";
    sha256 = "c83a058c417f98d75e62ab310e2995971bf79c99cd83cf1dcbd8a44797aa60c4";
    meta = with lib; {
      homepage = "https://github.com/M-Reimer/undoclosetab";
      description = "Allows you to restore the tab you just closed with a single click—plus it can offer a list of recently closed tabs within a convenient context menu.";
      license = licenses.gpl3;
      mozPermissions = ["menus" "tabs" "sessions" "storage" "theme"];
      platforms = platforms.all;
    };
  };
}
