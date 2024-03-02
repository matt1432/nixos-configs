{
  caddy-plugins,
  pkgs,
  config,
  ...
}: let
  inherit (config.vars) mainUser;
  inherit (config.sops) secrets;

  caddy = caddy-plugins.packages.${pkgs.system}.default;
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
      clusterIP = config.services.pcsd.virtualIps.caddy-vip.ip;
      nosIP = "10.0.0.121";
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
          vault.reverseProxy = "${nosIP}:8781";
          hauk.reverseProxy = "${nosIP}:3003";
          headscale.reverseProxy = "${clusterIP}:8085";
          jelly.reverseProxy = "${nosIP}:8097";

          # Resume builder
          resume.reverseProxy = "${nosIP}:3060";
          resauth.reverseProxy = "${nosIP}:3100";

          # Nextcloud & Co
          office.reverseProxy = "http://${nosIP}:8055";
          nextcloud = {
            subDomainName = "cloud";
            extraConfig = ''
              redir /.well-known/carddav /remote.php/dav 301
              redir /.well-known/caldav /remote.php/dav 301
              redir /.well-known/webfinger /index.php/.well-known/webfinger 301
              redir /.well-known/nodeinfo /index.php/.well-known/nodeinfo 301
            '';
            reverseProxy = "${nosIP}:8042";
          };

          forgejo = {
            subDomainName = "git";
            reverseProxy = "${nosIP}:3000";
          };

          nix-binary-cache = {
            subDomainName = "cache";
            reverseProxy = "${nosIP}:5000";
          };

          calibre = {
            subDomainName = "books";
            reverseProxy = "${nosIP}:8083";
          };

          immich = {
            subDomainName = "photos";
            reverseProxy = "${nosIP}:2283";
          };

          # FreshRSS & Co
          drss.reverseProxy = "${nosIP}:3007";
          freshrss = {
            subDomainName = "rss";
            reverseProxy = "${nosIP}:2800";
          };

          jellyseer = {
            subDomainName = "seerr";
            reverseProxy = "${nosIP}:5055";
          };

          gameyfin = {
            subDomainName = "games";
            reverseProxy = "${nosIP}:8074";
          };

          wgui.reverseProxy = "${nosIP}:51821";

          lan = {
            reverseProxy = "${nosIP}:3020";
            extraConfig = ''
              redir /index.html /
            '';

            subDirectories = {
              bazarr.reverseProxy = "${nosIP}:6767";
              bazarr-french = {
                subDirName = "bafrr";
                reverseProxy = "${nosIP}:6766";
              };

              prowlarr.reverseProxy = "${nosIP}:9696";
              radarr.reverseProxy = "${nosIP}:7878";
              sabnzbd.reverseProxy = "${nosIP}:8382";
              sonarr.reverseProxy = "${nosIP}:8989";

              calibre = {
                experimental = true;
                reverseProxy = "${nosIP}:8580";
              };

              qbittorent = {
                subDirName = "qbt";
                experimental = true;
                reverseProxy = "${nosIP}:8080";
              };

              vaultwarden = {
                subDirName = "vault";
                experimental = true;
                reverseProxy = "${nosIP}:8780";
              };
            };
          };

          # Top secret Business
          joal.extraConfig = ''
            route {
              rewrite * /joal/ui{uri}
              reverse_proxy * ${nosIP}:5656
            }
          '';
          joalws.extraConfig = ''
            route {
              reverse_proxy ${nosIP}:5656
            }
          '';
        };
      };
    };
  };
}
