{
  config,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;
  inherit (config.khepri) rwDataDir;

  rwPath = rwDataDir + "/freshrss";
in {
  khepri.compositions."freshrss".services = {
    "freshrss" = {
      image = import ./images/freshrss.nix pkgs;
      restart = "always";

      ports = ["2800:80"];
      extraHosts = [
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

      environmentFiles = [secrets.freshrss.path];

      environment = {
        TZ = "America/New_York";
        CRON_MIN = "3,33";
      };
    };

    "freshrss-db" = {
      image = import ./images/postgres.nix pkgs;
      restart = "always";

      volumes = [
        "${rwPath}/db:/var/lib/postgresql/data"
      ];

      environmentFiles = [secrets.freshrss.path];

      environment = {
        POSTGRES_DB = "\${DB_BASE:-freshrss}";
        POSTGRES_USER = "\${DB_USER:-freshrss}";
        POSTGRES_PASSWORD = "\${DB_PASSWORD:-freshrss}";
      };
    };

    "docker-hub-rss" = {
      image = import ./images/docker-hub-rss.nix pkgs;
      restart = "always";
      ports = ["3007:3000"];
    };

    "rss-bridge" = {
      image = import ./images/rss-bridge.nix pkgs;
      restart = "always";

      volumes = [
        "${rwPath}/bridge:/config"
      ];
      ports = ["3006:80"];
    };
  };
}
