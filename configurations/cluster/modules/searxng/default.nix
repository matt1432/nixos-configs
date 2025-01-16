{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mapAttrsToList;
in {
  services.searx = {
    enable = true;

    package = pkgs.searxng.overrideAttrs (o: {
      postInstall = ''
        ${o.postInstall or ""}
          # Replace logo
          cp ${./logo.png} $out/${pkgs.python3.sitePackages}/searx/static/themes/simple/img/searxng.png
      '';
    });

    environmentFile = config.sops.secrets.searxng.path;

    settings = {
      general = {
        instance_name = "Search";
        debug = false;
        enable_metrics = false;
      };

      search = {
        autocomplete = "google";
        favicon_resolver = "google";

        safe_search = 0;

        default_lang = "en-CA";
      };

      ui = {
        infinite_scroll = true;
        query_in_title = true;
        hotkeys = "vim";
      };

      server = {
        port = 8080;
        bind_address = config.services.pcsd.virtualIps.caddy-vip.ip;

        secret_key = "@SEARXNG_SECRET@";

        public_instance = false;
      };

      engines = mapAttrsToList (name: value: {inherit name;} // value) {
        "duckduckgo".disabled = false;
        "duckduckgo images".disabled = false;
        "gitlab".disabled = false;
        "qwant".disabled = false;
        "reddit".disabled = false;

        "wikipedia" = {
          engine = "wikipedia";
          shortcut = "w";
          base_url = "https://wikipedia.org/";
        };

        "github" = {
          engine = "github";
          shortcut = "gh";
        };
      };
    };
  };
}
