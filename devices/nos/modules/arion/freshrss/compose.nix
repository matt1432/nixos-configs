{
  config,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;
  inherit (config.arion) rwDataDir;

  rwPath = rwDataDir + "/freshrss";
in {
  arion.projects."freshrss" = {
    "freshrss" = {
      image = ./images/freshrss.nix;
      restart = "always";

      ports = ["2800:80"];
      extra_hosts = [
        "drss.nelim.org=10.0.0.130"
        "bridge.nelim.org=10.0.0.130"
      ];

      volumes = let
        rss-bridge = pkgs.stdenv.mkDerivation {
          name = "rss-bridge-ext";
          version = "unstable";
          src = pkgs.fetchFromGitHub {
            owner = "DevonHess";
            repo = "FreshRSS-Extensions";
            rev = "299c1febc279be77fa217ff5c2965a620903b974";
            hash = "sha256-++kgbrGJohKeOeLjcy7YV3QdCf9GyZDtbntlFmmIC5k=";
          };
          installPhase = ''
            mkdir $out
            cp -ar ./xExtension-RssBridge $out/
          '';
        };
      in [
        "${rwPath}/data:/var/www/FreshRSS/data"
        "${rss-bridge}/xExtension-RssBridge:/var/www/FreshRSS/extensions/xExtension-RssBridge:ro"
      ];

      env_file = [secrets.freshrss.path];

      environment = {
        TZ = "America/New_York";
        CRON_MIN = "3,33";
      };
    };

    "freshrss-db" = {
      image = ./images/postgres.nix;
      restart = "always";

      volumes = [
        "${rwPath}/db:/var/lib/postgresql/data"
      ];

      env_file = [secrets.freshrss.path];

      environment = {
        POSTGRES_DB = "\${DB_BASE:-freshrss}";
        POSTGRES_USER = "\${DB_USER:-freshrss}";
        POSTGRES_PASSWORD = "\${DB_PASSWORD:-freshrss}";
      };
    };

    "docker-hub-rss" = {
      image = ./images/docker-hub-rss.nix;
      restart = "always";
      ports = ["3007:3000"];
    };

    "rss-bridge" = {
      image = ./images/rss-bridge.nix;
      restart = "always";

      volumes = [
        "${rwPath}/bridge:/config"
      ];
      ports = ["3006:80"];
    };
  };
}
