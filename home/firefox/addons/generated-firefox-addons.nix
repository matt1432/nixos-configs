{
  buildFirefoxXpiAddon,
  fetchurl,
  lib,
  stdenv,
}: {
  "600-sound-volume" = buildFirefoxXpiAddon {
    pname = "600-sound-volume";
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
  "floccus" = buildFirefoxXpiAddon {
    pname = "floccus";
    version = "5.0.8";
    addonId = "floccus@handmadeideas.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/4218289/floccus-5.0.8.xpi";
    sha256 = "72c05ea95f1ec5ac3327d2060c9369e026117c17e90c7436cf124b833040e75e";
    meta = with lib; {
      homepage = "https://floccus.org";
      description = "Sync your bookmarks across browsers via Nextcloud, WebDAV or Google Drive";
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
  "ttv-lol-pro" = buildFirefoxXpiAddon {
    pname = "ttv-lol-pro";
    version = "2.3.4";
    addonId = "{76ef94a4-e3d0-4c6f-961a-d38a429a332b}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4231258/ttv_lol_pro-2.3.4.xpi";
    sha256 = "9b3255af18975e2c1f1b3c65b9c23d21403a4d086c74daef1ddc76a051f60516";
    meta = with lib; {
      homepage = "https://github.com/younesaassila/ttv-lol-pro";
      description = "TTV LOL PRO removes most livestream ads from Twitch.";
      license = licenses.gpl3;
      mozPermissions = [
        "proxy"
        "storage"
        "webRequest"
        "webRequestBlocking"
        "https://*.ttvnw.net/*"
        "https://*.twitch.tv/*"
        "https://perfprod.com/ttvlolpro/telemetry"
        "https://www.twitch.tv/*"
        "https://m.twitch.tv/*"
      ];
      platforms = platforms.all;
    };
  };
}
