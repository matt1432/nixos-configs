{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) head mapAttrsToList;
in {
  services.searx = {
    enable = true;

    package =
      (pkgs.searxng.override {
        # FIXME: https://pr-tracker.nelim.org/?pr=381174
        python3 = pkgs.python3.override {
          packageOverrides = pyFinal: pyPrev: {
            httpx = pyPrev.httpx.overridePythonAttrs (o: rec {
              version = "0.27.2";
              src = pkgs.fetchFromGitHub {
                owner = "encode";
                repo = o.pname;
                tag = version;
                hash = "sha256-N0ztVA/KMui9kKIovmOfNTwwrdvSimmNkSvvC+3gpck=";
              };
            });
            starlette = pyPrev.starlette.overridePythonAttrs (o: rec {
              version = "0.41.2";
              src = pkgs.fetchFromGitHub {
                owner = "encode";
                repo = "starlette";
                tag = version;
                hash = "sha256-ZNB4OxzJHlsOie3URbUnZywJbqOZIvzxS/aq7YImdQ0=";
              };
            });
            httpx-socks = pyPrev.httpx-socks.overridePythonAttrs (o: rec {
              version = "0.9.2";
              src = pkgs.fetchFromGitHub {
                owner = "romis2012";
                repo = "httpx-socks";
                tag = "v${version}";
                hash = "sha256-PUiciSuDCO4r49st6ye5xPLCyvYMKfZY+yHAkp5j3ZI=";
              };
            });
          };
        };
      })
      .overrideAttrs (o: {
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
        bind_address = (head config.services.pcsd.virtualIps).ip;

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
