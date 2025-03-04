{configPath, ...}: {
  config,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;

  rwPath = configPath + "/freshrss";
in {
  virtualisation.docker.compose."freshrss" = {
    networks.proxy_net = {external = true;};

    services = {
      "freshrss" = {
        image = pkgs.callPackage ./images/freshrss.nix pkgs;
        restart = "always";

        ports = ["2800:80"];
        networks = ["proxy_net"];

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
        image = pkgs.callPackage ./images/postgres.nix pkgs;
        restart = "always";

        volumes = [
          "${rwPath}/db:/var/lib/postgresql/data"
        ];

        networks = ["proxy_net"];

        env_file = [secrets.freshrss.path];

        environment = {
          POSTGRES_DB = "\${DB_BASE:-freshrss}";
          POSTGRES_USER = "\${DB_USER:-freshrss}";
          POSTGRES_PASSWORD = "\${DB_PASSWORD:-freshrss}";
        };
      };

      "bridge.nelim.org" = {
        image = pkgs.callPackage ./images/rss-bridge.nix pkgs;
        restart = "always";

        volumes = [
          "${rwPath}/bridge:/config"
        ];
        ports = ["3006:80"];

        networks = ["proxy_net"];
      };
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
