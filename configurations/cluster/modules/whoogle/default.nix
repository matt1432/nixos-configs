{
  config,
  lib,
  ...
}: let
  inherit (lib) head replaceStrings;
in {
  services.whoogle-search = {
    enable = true;

    port = 8080;
    listenAddress = (head config.services.pcsd.virtualIps).ip;

    extraEnv = {
      WHOOGLE_UPDATE_CHECK = "false";

      WHOOGLE_CONFIG_VIEW_IMAGE = "true";
      WHOOGLE_CONFIG_URL = "http://search.nelim.org/";

      # https://github.com/benbusby/whoogle-search/wiki/User-Contributed-CSS-Themes#dracula-unleashed-theme-by-hypertoken
      WHOOGLE_CONFIG_STYLE =
        replaceStrings
        ["\n"]
        [" "]
        /*
        css
        */
        ''
          :root {
            /* LIGHT THEME COLORS (Dracula-inspired) */
            --whoogle-logo: #bd93f9;
            --whoogle-page-bg: #f8f8f2;
            --whoogle-element-bg: #e9e9f4;
            --whoogle-text: #282a36;
            --whoogle-contrast-text: #8be9fd;
            --whoogle-secondary-text: #6272a4;
            --whoogle-result-bg: #ffffff;
            --whoogle-result-title: #50fa7b;
            --whoogle-result-url: #bd93f9;
            --whoogle-result-visited: #ff79c6;

            /* DARK THEME COLORS (True Dracula) */
            --whoogle-dark-logo: #bd93f9;
            --whoogle-dark-page-bg: #282a36;
            --whoogle-dark-element-bg: #44475a;
            --whoogle-dark-text: #f8f8f2;
            --whoogle-dark-contrast-text: #8be9fd;
            --whoogle-dark-secondary-text: #6272a4;
            --whoogle-dark-result-bg: #282a36;
            --whoogle-dark-result-title: #50fa7b;
            --whoogle-dark-result-url: #bd93f9;
            --whoogle-dark-result-visited: #ff79c6;
          }
          #whoogle-w {
            fill: #8be9fd;
          }
          #whoogle-h {
            fill: #50fa7b;
          }
          #whoogle-o-1 {
            fill: #ffb86c;
          }
          #whoogle-o-2 {
            fill: #ff79c6;
          }
          #whoogle-g {
            fill: #bd93f9;
          }
          #whoogle-l {
            fill: #ff5555;
          }
          #whoogle-e {
            fill: #f1fa8c;
          }
        '';
    };
  };
}
