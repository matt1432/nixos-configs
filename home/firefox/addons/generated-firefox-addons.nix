{
  buildFirefoxXpiAddon,
  fetchurl,
  lib,
  stdenv,
}: {
  "600-sound-volume" = buildFirefoxXpiAddon {
    pname = "600-sound-volume";
    version = "1.5.3";
    addonId = "{c4b582ec-4343-438c-bda2-2f691c16c262}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4133303/600_sound_volume-1.5.3.xpi";
    sha256 = "7045a812608338f95181459ae3e518bb51c8dc9a724a4083afb687d14075c304";
    meta = with lib; {
      homepage = "http://resourcefulman.net/";
      description = "Up to 600% volume boost";
      license = licenses.mpl20;
      mozPermissions = ["<all_urls>" "tabs" "activeTab" "storage"];
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
    version = "2.2.1";
    addonId = "{76ef94a4-e3d0-4c6f-961a-d38a429a332b}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4179399/ttv_lol_pro-2.2.1.xpi";
    sha256 = "83d012878021fb5fe25bee1101a7a760974ae9e2949b80fd99b73d3da48b1f99";
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
