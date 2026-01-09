{
  buildFirefoxXpiAddon,
  fetchurl,
  lib,
  stdenv,
}: {
  "bitwarden" = buildFirefoxXpiAddon {
    pname = "bitwarden";
    version = "2025.12.0";
    addonId = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4640726/bitwarden_password_manager-2025.12.0.xpi";
    sha256 = "0256a61e84e23903fd379f5971150a8b23a53a126da62d276d57e514408839cd";
    meta = with lib; {
      homepage = "https://bitwarden.com";
      description = "At home, at work, or on the go, Bitwarden easily secures all your passwords, passkeys, and sensitive information.";
      license = licenses.gpl3;
      mozPermissions = [
        "<all_urls>"
        "*://*/*"
        "alarms"
        "clipboardRead"
        "clipboardWrite"
        "contextMenus"
        "idle"
        "storage"
        "tabs"
        "unlimitedStorage"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
        "notifications"
        "file:///*"
      ];
      platforms = platforms.all;
    };
  };
  "darkreader" = buildFirefoxXpiAddon {
    pname = "darkreader";
    version = "4.9.118";
    addonId = "addon@darkreader.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/4638146/darkreader-4.9.118.xpi";
    sha256 = "69d2da0e84545ee19ded9a5872f300765280cf25b2edbef7041d4d752c4c9394";
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
    version = "5.8.3";
    addonId = "floccus@handmadeideas.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/4647430/floccus-5.8.3.xpi";
    sha256 = "df30c8f936e6f844fe977aaeecf0bfe16536b7617ce890cc68a64e14b884cfed";
    meta = with lib; {
      homepage = "https://floccus.org";
      description = "Securely synchronize bookmarks across Chrome, Firefox, Edge, and more using your own cloud storage.";
      license = licenses.mpl20;
      mozPermissions = [
        "*://*/*"
        "alarms"
        "bookmarks"
        "storage"
        "unlimitedStorage"
        "tabs"
        "tabGroups"
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
    version = "1.1.9";
    addonId = "idcac-pub@guus.ninja";
    url = "https://addons.mozilla.org/firefox/downloads/file/4637154/istilldontcareaboutcookies-1.1.9.xpi";
    sha256 = "42922f61cfc53e2103e492ddbe5736caf503d9dad4a88690efc4c64dac10d5c7";
    meta = with lib; {
      homepage = "https://github.com/OhMyGuus/I-Dont-Care-About-Cookies";
      description = "Community version of the popular extension \"I don't care about cookies\"  \n\nhttps://github.com/OhMyGuus/I-Dont-Care-About-Cookies";
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
  "return-youtube-dislikes" = buildFirefoxXpiAddon {
    pname = "return-youtube-dislikes";
    version = "3.0.0.18";
    addonId = "{762f9885-5a13-4abd-9c77-433dcd38b8fd}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4371820/return_youtube_dislikes-3.0.0.18.xpi";
    sha256 = "2d33977ce93276537543161f8e05c3612f71556840ae1eb98239284b8f8ba19e";
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
    version = "2.0.4";
    addonId = "{c4b582ec-4343-438c-bda2-2f691c16c262}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4462455/600_sound_volume-2.0.4.xpi";
    sha256 = "72e3b7ea83cefc4c72f4c22cb2875b77c4e0f2c0db743445b5aa70f09d0291ac";
    meta = with lib; {
      description = "Up to 600% volume boost";
      license = licenses.mpl20;
      mozPermissions = [
        "<all_urls>"
        "tabs"
        "storage"
        "webRequest"
        "webRequestBlocking"
      ];
      platforms = platforms.all;
    };
  };
  "sponsorblock" = buildFirefoxXpiAddon {
    pname = "sponsorblock";
    version = "6.1.2";
    addonId = "sponsorBlocker@ajay.app";
    url = "https://addons.mozilla.org/firefox/downloads/file/4644570/sponsorblock-6.1.2.xpi";
    sha256 = "598f66c9eb6bbab2bd5f87376b632a5860f442d3694e233610f5b37f8b6e3f10";
    meta = with lib; {
      homepage = "https://sponsor.ajay.app";
      description = "Easily skip YouTube video sponsors. When you visit a YouTube video, the extension will check the database for reported sponsors and automatically skip known sponsors. You can also report sponsors in videos. Other browsers: https://sponsor.ajay.app";
      license = licenses.lgpl3;
      mozPermissions = [
        "storage"
        "scripting"
        "unlimitedStorage"
        "https://sponsor.ajay.app/*"
        "https://*.youtube.com/*"
        "https://www.youtube-nocookie.com/embed/*"
      ];
      platforms = platforms.all;
    };
  };
  "stylus" = buildFirefoxXpiAddon {
    pname = "stylus";
    version = "2.3.19";
    addonId = "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4661054/styl_us-2.3.19.xpi";
    sha256 = "f479caf673b2f1b1f821d16f5c341a52433542930a9a2597c81f0798b4ecaa32";
    meta = with lib; {
      homepage = "https://add0n.com/stylus.html";
      description = "Redesign your favorite websites with Stylus, an actively developed and community driven userstyles manager. Easily install custom themes from popular online repositories, or create, edit, and manage your own personalized CSS stylesheets.";
      license = licenses.gpl3;
      mozPermissions = [
        "alarms"
        "contextMenus"
        "storage"
        "tabs"
        "unlimitedStorage"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
        "<all_urls>"
        "https://userstyles.org/*"
      ];
      platforms = platforms.all;
    };
  };
  "tampermonkey" = buildFirefoxXpiAddon {
    pname = "tampermonkey";
    version = "5.4.1";
    addonId = "firefox@tampermonkey.net";
    url = "https://addons.mozilla.org/firefox/downloads/file/4624137/tampermonkey-5.4.1.xpi";
    sha256 = "60f3f2bc86d43a3f5704b4878490beb7f4c44d27c14ac8747845082fe1773ad0";
    meta = with lib; {
      homepage = "https://tampermonkey.net";
      description = "Tampermonkey is the world's most popular userscript manager.";
      mozPermissions = [
        "alarms"
        "notifications"
        "tabs"
        "idle"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
        "unlimitedStorage"
        "storage"
        "contextMenus"
        "clipboardWrite"
        "cookies"
        "downloads"
        "<all_urls>"
      ];
      platforms = platforms.all;
    };
  };
  "ublock-origin" = buildFirefoxXpiAddon {
    pname = "ublock-origin";
    version = "1.68.0";
    addonId = "uBlock0@raymondhill.net";
    url = "https://addons.mozilla.org/firefox/downloads/file/4629131/ublock_origin-1.68.0.xpi";
    sha256 = "5caf4abda494018841222a12156919bbdd8cad82a783c38c36b22dd642704315";
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
    version = "8.1.0";
    addonId = "{4853d046-c5a3-436b-bc36-220fd935ee1d}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4513641/undoclosetabbutton-8.1.0.xpi";
    sha256 = "ff9a47b466fe29a860a1846a65502e327717945dc9f7ce627c9cd64a2859baab";
    meta = with lib; {
      homepage = "https://github.com/M-Reimer/undoclosetab";
      description = "Allows you to restore the tab you just closed with a single click—plus it can offer a list of recently closed tabs within a convenient context menu.";
      license = licenses.gpl3;
      mozPermissions = ["menus" "tabs" "sessions" "storage" "theme"];
      platforms = platforms.all;
    };
  };
}
