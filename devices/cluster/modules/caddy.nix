{
  caddy-plugins,
  pkgs,
  config,
  ...
}: let
  inherit (config.vars) hostName mainUser;
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
      serviviIP = "10.0.0.249";

      tlsConf = ''
        tls {
          dns cloudflare {$CLOUDFLARE_API_TOKEN}
          resolvers 1.0.0.1
        }
      '';

      mkPublicReverseProxy = subdomain: ip: extraConf:
        {
          hostName = "${subdomain}.nelim.org";
          reverseProxy = ip;
          listenAddresses = [clusterIP];
          extraConfig = tlsConf + (extraConf.extraConfig or "");
        }
        // (builtins.removeAttrs extraConf ["extraConfig"]);
    in {
      # Public
      "Vaultwarden" = mkPublicReverseProxy "vault" "${nosIP}:8781" {};
      "Hauk" = mkPublicReverseProxy "hauk" "${nosIP}:3003" {};
      "Headscale" = mkPublicReverseProxy "headscale" "${clusterIP}:8085" {};

      "Jellyfin" = mkPublicReverseProxy "jelly" "${nosIP}:8096" {
        subDirectories.jfa-go = {
          subDirName = "accounts";
          reverseProxy = "${nosIP}:8056";
        };
      };

      "Jellyseer" = mkPublicReverseProxy "seerr" "${nosIP}:5055" {};

      "Gameyfin" = mkPublicReverseProxy "games" "${nosIP}:8074" {};

      "Forgejo" = mkPublicReverseProxy "git" "${nosIP}:3000" {};

      "Nextcloud" = mkPublicReverseProxy "cloud" "${nosIP}:8042" {
        extraConfig = ''
          redir /.well-known/carddav /remote.php/dav 301
          redir /.well-known/caldav /remote.php/dav 301
          redir /.well-known/webfinger /index.php/.well-known/webfinger 301
          redir /.well-known/nodeinfo /index.php/.well-known/nodeinfo 301
        '';
      };
      "OnlyOffice" = mkPublicReverseProxy "office" "http://${nosIP}:8055" {};

      "Immich" = mkPublicReverseProxy "photos" "${nosIP}:2283" {};

      # Private
      "nelim.org" = {
        serverAliases = ["*.nelim.org"];
        extraConfig = tlsConf;
        listenAddresses = [
          (
            if hostName == "thingone"
            then "100.64.0.8"
            else "100.64.0.9"
          )
        ];

        subDomains = {
          pr-tracker.reverseProxy = "${serviviIP}:3000";

          pcsd = {
            extraConfig = ''
              reverse_proxy https://${clusterIP}:2224 {
                  transport http {
                      tls_insecure_skip_verify
                  }
              }
            '';
          };

          nix-binary-cache = {
            subDomainName = "cache";
            reverseProxy = "${serviviIP}:5000";
          };

          # Resume builder
          resume.reverseProxy = "${nosIP}:3060";
          resauth.reverseProxy = "${nosIP}:3100";

          # FreshRSS & Co
          bridge.reverseProxy = "${nosIP}:3006";
          drss.reverseProxy = "${nosIP}:3007";
          freshrss = {
            subDomainName = "rss";
            reverseProxy = "${nosIP}:2800";
          };

          wgui.reverseProxy = "${nosIP}:51821";

          lan = {
            reverseProxy = "${nosIP}:3020";
            extraConfig = ''
              redir /index.html /
            '';

            subDirectories = {
              bazarr.reverseProxy = "${nosIP}:6767";
              prowlarr.reverseProxy = "${nosIP}:9696";
              radarr.reverseProxy = "${nosIP}:7878";
              sabnzbd.reverseProxy = "${nosIP}:8382";
              sonarr.reverseProxy = "${nosIP}:8989";

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
