{
  caddy-plugins,
  pkgs,
  config,
  ...
}: let
  user = config.services.device-vars.username;

  caddy = caddy-plugins.packages.${pkgs.system}.default;

  # TODO: use agenix?
  verySecretToken = "TODO";
in {
  imports = [caddy-plugins.nixosModules.default];
  environment.systemPackages = [caddy];
  users.users.${user}.extraGroups = ["caddy"];

  services.caddy = {
    enable = true;
    enableReload = false;
    package = caddy;

    virtualHosts = {
      "http://pi.hole".reverseProxy = "localhost:8000";

      "nelim.org" = let
        mainIP = "10.0.0.122";
        jellyIP = "10.0.0.123";
      in {
        serverAliases = ["*.nelim.org"];
        extraConfig = ''
           tls {
             dns cloudflare ${verySecretToken}
             resolvers 1.0.0.1
          }
        '';

        subDomains = {
          # Misc one-liners
          vault.reverseProxy = "${mainIP}:8781";
          hauk.reverseProxy = "${mainIP}:3003";
          headscale.reverseProxy = "localhost:8085";
          jelly.reverseProxy = "${jellyIP}:80";

          # Resume builder
          resume.reverseProxy = "${mainIP}:3060";
          resauth.reverseProxy = "${mainIP}:3100";

          # Nextcloud & Co
          bakail.reverseProxy = "${mainIP}:8077";
          office.reverseProxy = "http://${mainIP}:8055";
          nextcloud = {
            subDomainName = "cloud";
            extraConfig = ''
              redir /.well-known/carddav /remote.php/dav 301
              redir /.well-known/caldav /remote.php/dav 301
              redir /.well-known/webfinger /index.php/.well-known/webfinger 301
              redir /.well-known/nodeinfo /index.php/.well-known/nodeinfo 301
            '';
            reverseProxy = "${mainIP}:8042";
          };

          forgejo = {
            subDomainName = "git";
            reverseProxy = "${mainIP}:3000";
          };

          calibre = {
            subDomainName = "books";
            reverseProxy = "${mainIP}:8083";
          };

          immich = {
            subDomainName = "photos";
            reverseProxy = "${mainIP}:2283";
          };

          # FreshRSS & Co
          drss.reverseProxy = "${mainIP}:3007";
          freshrss = {
            subDomainName = "rss";
            reverseProxy = "${mainIP}:2800";
          };

          jellyseer = {
            subDomainName = "seerr";
            reverseProxy = "${mainIP}:5055";
          };

          games.reverseProxy = "${mainIP}:8074";

          # FIXME: what's the IP?
          #wgui.extraConfig = ''
          #  reverse_proxy ???:51821
          #'';

          lan = {
            reverseProxy = "10.0.0.122:3020";
            extraConfig = ''
              redir /index.html /
            '';

            subDirectories = {
              bazarr.reverseProxy = "10.0.0.122:6767";
              bazarr-french = {
                subDirName = "bafrr";
                reverseProxy = "10.0.0.122:6766";
              };

              prowlarr.reverseProxy = "10.0.0.122:9696";
              radarr.reverseProxy = "10.0.0.122:7878";
              sabnzbd.reverseProxy = "10.0.0.122:8382";
              sonarr.reverseProxy = "10.0.0.122:8989";

              calibre = {
                experimental = true;
                reverseProxy = "10.0.0.122:8580";
              };

              qbittorent = {
                subDirName = "qbt";
                experimental = true;
                reverseProxy = "10.0.0.128:8080";
              };

              vaultwarden = {
                subDirName = "vault";
                experimental = true;
                reverseProxy = "10.0.0.122:8780";
              };
            };
          };

          # Top secret Business
          joal.extraConfig = ''
            route {
              rewrite * /joal/ui{uri}
              reverse_proxy * ${mainIP}:5656
            }
          '';
          joalws.extraConfig = ''
            route {
              reverse_proxy ${mainIP}:5656
            }
          '';
        };
      };
    };
  };
}
