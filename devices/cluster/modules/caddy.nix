{
  caddy-plugins,
  pkgs,
  config,
  ...
}: let
  inherit (config.vars) mainUser;
  inherit (config.sops) secrets;

  caddy = caddy-plugins.packages.${pkgs.system}.default;

  clusterIP = config.services.pcsd.virtualIps.caddy-vip.ip;
in {
  imports = [caddy-plugins.nixosModules.default];

  # User stuff
  environment.systemPackages = [caddy];
  users.users.${mainUser}.extraGroups = ["caddy"];

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
      servivi = "10.0.0.249";
    in {
      "nelim.org" = {
        serverAliases = ["*.nelim.org"];
        extraConfig = ''
           tls {
             dns cloudflare {$CLOUDFLARE_API_TOKEN}
             resolvers 1.0.0.1
          }
        '';

        subDomains = {
          # Misc one-liners
          vault.reverseProxy = "${servivi}:8781";
          hauk.reverseProxy = "${servivi}:3003";
          headscale.reverseProxy = "${clusterIP}:8085";
          jelly.reverseProxy = "${jellyIP}:80";

          # Resume builder
          resume.reverseProxy = "${servivi}:3060";
          resauth.reverseProxy = "${servivi}:3100";

          # Nextcloud & Co
          office.reverseProxy = "http://${servivi}:8055";
          nextcloud = {
            subDomainName = "cloud";
            extraConfig = ''
              redir /.well-known/carddav /remote.php/dav 301
              redir /.well-known/caldav /remote.php/dav 301
              redir /.well-known/webfinger /index.php/.well-known/webfinger 301
              redir /.well-known/nodeinfo /index.php/.well-known/nodeinfo 301
            '';
            reverseProxy = "${servivi}:8042";
          };

          forgejo = {
            subDomainName = "git";
            reverseProxy = "${servivi}:3000";
          };

          nix-binary-cache = {
            subDomainName = "cache";
            reverseProxy = "${servivi}:5000";
          };

          calibre = {
            subDomainName = "books";
            reverseProxy = "${dockerIP}:8083";
          };

          immich = {
            subDomainName = "photos";
            reverseProxy = "${servivi}:2283";
          };

          # FreshRSS & Co
          drss.reverseProxy = "${servivi}:3007";
          freshrss = {
            subDomainName = "rss";
            reverseProxy = "${servivi}:2800";
          };

          jellyseer = {
            subDomainName = "seerr";
            reverseProxy = "${dockerIP}:5055";
          };

          games.reverseProxy = "${dockerIP}:8074";

          wgui.reverseProxy = "${servivi}:51821";

          lan = {
            reverseProxy = "${servivi}:3020";
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
                reverseProxy = "${servivi}:8080";
              };

              vaultwarden = {
                subDirName = "vault";
                experimental = true;
                reverseProxy = "${servivi}:8780";
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
