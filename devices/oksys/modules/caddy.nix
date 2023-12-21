{
  caddy-plugins,
  pkgs,
  config,
  ...
}: let
  caddy = caddy-plugins.packages.${pkgs.system}.default;
  secrets = config.sops.secrets;
in {
  imports = [caddy-plugins.nixosModules.default];
  environment.systemPackages = [caddy];
  users.users.${config.vars.user}.extraGroups = ["caddy"];

  systemd.services.caddy.serviceConfig = {
    EnvironmentFile = secrets.caddy-cloudflare.path;

    # For some reason the service
    # doesn't shutdown normally
    KillSignal = "SIGKILL";
    RestartKillSignal = "SIGKILL";
  };

  services.caddy = {
    enable = true;
    enableReload = false;
    package = caddy;

    virtualHosts = let
      dockerIP = "10.0.0.122";
      jellyIP = "10.0.0.123";
    in {
      "nelim.org" = {
        serverAliases = ["*.nelim.org"];
        extraConfig = ''
           tls {
             dns cloudflare {$TLS}
             resolvers 1.0.0.1
          }
        '';

        subDomains = {
          # Misc one-liners
          vault.reverseProxy = "${dockerIP}:8781";
          hauk.reverseProxy = "${dockerIP}:3003";
          headscale.reverseProxy = "localhost:8085";
          jelly.reverseProxy = "${jellyIP}:80";

          # Resume builder
          resume.reverseProxy = "${dockerIP}:3060";
          resauth.reverseProxy = "${dockerIP}:3100";

          # Nextcloud & Co
          bakail.reverseProxy = "${dockerIP}:8077";
          office.reverseProxy = "http://${dockerIP}:8055";
          nextcloud = {
            subDomainName = "cloud";
            extraConfig = ''
              redir /.well-known/carddav /remote.php/dav 301
              redir /.well-known/caldav /remote.php/dav 301
              redir /.well-known/webfinger /index.php/.well-known/webfinger 301
              redir /.well-known/nodeinfo /index.php/.well-known/nodeinfo 301
            '';
            reverseProxy = "${dockerIP}:8042";
          };

          forgejo = {
            subDomainName = "git";
            reverseProxy = "${dockerIP}:3000";
          };

          calibre = {
            subDomainName = "books";
            reverseProxy = "${dockerIP}:8083";
          };

          immich = {
            subDomainName = "photos";
            reverseProxy = "${dockerIP}:2283";
          };

          # FreshRSS & Co
          drss.reverseProxy = "${dockerIP}:3007";
          freshrss = {
            subDomainName = "rss";
            reverseProxy = "${dockerIP}:2800";
          };

          jellyseer = {
            subDomainName = "seerr";
            reverseProxy = "${dockerIP}:5055";
          };

          games.reverseProxy = "${dockerIP}:8074";

          # FIXME: what's the IP?
          #wgui.extraConfig = ''
          #  reverse_proxy ???:51821
          #'';

          lan = {
            reverseProxy = "${dockerIP}:3020";
            extraConfig = ''
              redir /index.html /
            '';

            subDirectories = {
              bazarr.reverseProxy = "${dockerIP}:6767";
              bazarr-french = {
                subDirName = "bafrr";
                reverseProxy = "${dockerIP}:6766";
              };

              prowlarr.reverseProxy = "${dockerIP}:9696";
              radarr.reverseProxy = "${dockerIP}:7878";
              sabnzbd.reverseProxy = "${dockerIP}:8382";
              sonarr.reverseProxy = "${dockerIP}:8989";

              calibre = {
                experimental = true;
                reverseProxy = "${dockerIP}:8580";
              };

              qbittorent = {
                subDirName = "qbt";
                experimental = true;
                reverseProxy = "10.0.0.128:8080";
              };

              vaultwarden = {
                subDirName = "vault";
                experimental = true;
                reverseProxy = "${dockerIP}:8780";
              };
            };
          };

          # Top secret Business
          joal.extraConfig = ''
            route {
              rewrite * /joal/ui{uri}
              reverse_proxy * ${dockerIP}:5656
            }
          '';
          joalws.extraConfig = ''
            route {
              reverse_proxy ${dockerIP}:5656
            }
          '';
        };
      };
    };
  };
}
