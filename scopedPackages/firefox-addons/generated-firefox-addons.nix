{
  buildMozillaXpiAddon,
  fetchurl,
  lib,
  stdenv,
}: {
  "bitwarden" = buildMozillaXpiAddon {
    pname = "bitwarden";
    version = "2026.10.2";
    addonId = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
    url = "https://addons.mozilla.org/firefox/downloads/file/5198653/bitwarden_password_manager-2026.10.2.xpi";
    sha256 = "abf9d7273dd55ac0583ecc6997f7f7ae3d29de11e2ad0a4838b80e2b941daa73";
    meta = with lib; {
      homepage = "https://bitwarden.com";
      description = "At home, at work, or on the go, Bitwarden easily secures all your passwords, passkeys, and sensitive information.";
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
  "darkreader" = buildMozillaXpiAddon {
    pname = "darkreader";
    version = "4.9.135";
    addonId = "addon@darkreader.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/5216111/darkreader-4.9.135.xpi";
    sha256 = "bfed4591d6cc69857f5ed33a2d3cbfbc5811d5b92c4323d0735d2f1757e2dce4";
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
  "floccus" = buildMozillaXpiAddon {
    pname = "floccus";
    version = "5.13.0";
    addonId = "floccus@handmadeideas.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/5224106/floccus-5.13.0.xpi";
    sha256 = "71f658e689e67c17b3c605503e64400fa05c730618365b8d023b8e63bd1c8473";
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
  "google-container" = buildMozillaXpiAddon {
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
  "image-search-options" = buildMozillaXpiAddon {
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
  "istilldontcareaboutcookies" = buildMozillaXpiAddon {
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
  "return-youtube-dislikes" = buildMozillaXpiAddon {
    pname = "return-youtube-dislikes";
    version = "4.1.7";
    addonId = "{762f9885-5a13-4abd-9c77-433dcd38b8fd}";
    url = "https://addons.mozilla.org/firefox/downloads/file/5222672/return_youtube_dislikes-4.1.7.xpi";
    sha256 = "ac52f0786bbf4e4a669009be0e2847c21c642e60cfe358c01a80057c52d507d6";
    meta = with lib; {
      description = "Returns ability to see dislike statistics on youtube";
      license = licenses.gpl3;
      mozPermissions = [
        "activeTab"
        "*://*.youtube.com/*"
        "storage"
        "*://returnyoutubedislikeapi.com/*"
        "identity"
      ];
      platforms = platforms.all;
    };
  };
  "sponsorblock" = buildMozillaXpiAddon {
    pname = "sponsorblock";
    version = "6.1.7";
    addonId = "sponsorBlocker@ajay.app";
    url = "https://addons.mozilla.org/firefox/downloads/file/4897574/sponsorblock-6.1.7.xpi";
    sha256 = "0d50e1632c6f15ee15a543e670e1c572974605a5c02622916e08e026803df83f";
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
  "stylus" = buildMozillaXpiAddon {
    pname = "stylus";
    version = "2.4.17";
    addonId = "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}";
    url = "https://addons.mozilla.org/firefox/downloads/file/5142667/styl_us-2.4.17.xpi";
    sha256 = "6ea20f86a2015e3e7a639e2dbb13bc0d63461fdfdb80d7138c3f8e8924e4fb1c";
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
  "tampermonkey" = buildMozillaXpiAddon {
    pname = "tampermonkey";
    version = "5.5.0";
    addonId = "firefox@tampermonkey.net";
    url = "https://addons.mozilla.org/firefox/downloads/file/4797143/tampermonkey-5.5.0.xpi";
    sha256 = "190031c78dbc5696114835601f2c8e6b855ad1e134df5df278f8fc158c065908";
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
        "contextualIdentities"
        "downloads"
        "<all_urls>"
      ];
      platforms = platforms.all;
    };
  };
  "ublock-origin" = buildMozillaXpiAddon {
    pname = "ublock-origin";
    version = "1.76.0";
    addonId = "uBlock0@raymondhill.net";
    url = "https://addons.mozilla.org/firefox/downloads/file/5225273/ublock_origin-1.76.0.xpi";
    sha256 = "6f20ff6749193599548770539103069c20948dfcd3e61c3089a67da7bfc3be39";
    meta = with lib; {
      homepage = "https://github.com/gorhill/uBlock#ublock-origin";
      description = "Finally, an efficient wide-spectrum content blocker. Easy on CPU and memory.";
      license = licenses.gpl3;
      mozPermissions = [
        "alarms"
        "dns"
        "menus"
        "privacy"
        "publicSuffix"
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
  "undoclosetabbutton" = buildMozillaXpiAddon {
    pname = "undoclosetabbutton";
    version = "8.1.1";
    addonId = "{4853d046-c5a3-436b-bc36-220fd935ee1d}";
    url = "https://addons.mozilla.org/firefox/downloads/file/5169497/undoclosetabbutton-8.1.1.xpi";
    sha256 = "57ce71a53686083960b8c0c66b1b983445c77b51cb55e2f0ea1ac0338d3e0d07";
    meta = with lib; {
      homepage = "https://github.com/M-Reimer/undoclosetab";
      description = "Allows you to restore the tab you just closed with a single click—plus it can offer a list of recently closed tabs within a convenient context menu.";
      license = licenses.gpl3;
      mozPermissions = ["menus" "tabs" "sessions" "storage" "theme"];
      platforms = platforms.all;
    };
  };
  "youtube-no-translation" = buildMozillaXpiAddon {
    pname = "youtube-no-translation";
    version = "2.26.1";
    addonId = "{9a3104a2-02c2-464c-b069-82344e5ed4ec}";
    url = "https://addons.mozilla.org/firefox/downloads/file/5178154/youtube_no_translation-2.26.1.xpi";
    sha256 = "c850e92de937879067919eb7f683160e0159feb0271d2abc011a663481d50cf3";
    meta = with lib; {
      description = "Keeps YouTube content in its original language (Titles, Audio Tracks, Descriptions...)";
      mozPermissions = [
        "storage"
        "*://*.youtube.com/*"
        "*://*.youtube-nocookie.com/*"
      ];
      platforms = platforms.all;
    };
  };
  "youtubelistview" = buildMozillaXpiAddon {
    pname = "youtubelistview";
    version = "1.628";
    addonId = "@idk-what-this-means";
    url = "https://addons.mozilla.org/firefox/downloads/file/4790249/youtubelistview-1.628.xpi";
    sha256 = "b610f7d7829ce222f192e88fe2998b07647643ed5db2c2fefbf2ababcdc6aea3";
    meta = with lib; {
      description = "Brings back the list view for the subscriptions page and more. Click the extension icon for customization options.";
      mozPermissions = ["storage" "https://www.youtube.com/*"];
      platforms = platforms.all;
    };
  };
}
