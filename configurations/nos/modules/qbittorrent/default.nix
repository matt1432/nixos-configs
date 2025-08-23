{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.qbittorrent;
in {
  imports = [
    ./wireguard.nix
  ];

  users.groups."matt" = {
    gid = 1000;
    members = ["matt"];
  };

  services.qbittorrent = {
    enable = true;

    user = "matt";
    group = "matt";

    serverConfig = {
      Application.FileLogger = {
        Enabled = true;

        Age = "1";
        AgeType = "1";
        Backup = true;
        DeleteOld = true;
        MaxSizeBytes = "66560";
        Path = "${cfg.profileDir}/logs";
      };

      AutoRun = {
        enabled = false;
        program = "";

        OnTorrentAdded = {
          Enabled = false;
          Program = "";
        };
      };

      BitTorrent.Session = {
        # WireGuard
        Interface = "wg0";
        InterfaceName = "wg0";
        Port = "51820";

        # Misc Network
        ShareLimitAction = "Stop";
        ReannounceWhenAddressChanged = true;
        SSL.Port = "20534";

        # Saving Folder
        TempPathEnabled = true;
        TempPath = "/data/downloads/incomplete";
        DefaultSavePath = "/data/downloads/done";

        AddTorrentStopped = false;
        Preallocation = true;
        QueueingSystemEnabled = false;
        ExcludedFileNames = "";
      };

      Core.AutoDeleteAddedTorrentFile = "Never";

      Network = {
        Cookies = "@Invalid()";

        PortForwardingEnabled = true;

        Proxy = {
          HostnameLookupEnabled = false;

          Profiles = {
            BitTorrent = true;
            Misc = true;
            RSS = true;
          };
        };
      };

      Preferences = {
        General.Locale = "en";

        WebUI = {
          # VueTorrent
          AlternativeUIEnabled = true;
          RootFolder = "${pkgs.vuetorrent}/share/vuetorrent";

          # Network
          Address = "*";
          Port = "8080";
          UseUPnP = false;

          # Reverse Proxy
          ReverseProxySupportEnabled = false;
          TrustedReverseProxiesList = "";
          ServerDomains = "*";

          # Auth
          Username = "admin";
          Password_PBKDF2 = "@ByteArray(BlV/LXQy3Rfzs25CHrgy1A==:0JQioz22kb1hvDgQ+D9UOmKlkENfqx6KXCBok/9vpIJStTmCcwsBG/QnkYNgoCmYnoORzbJelZ1AR7yXwx8MuA==)";
          LocalHostAuth = true;
          AuthSubnetWhitelistEnabled = false;
          MaxAuthenticationFailCount = "5";
          BanDuration = "3600";
          SessionTimeout = "3600";

          # HTTP
          CustomHTTPHeaders = "";
          CustomHTTPHeadersEnabled = false;
          HTTPS = {
            Enabled = false;
            CertificatePath = "";
            KeyPath = "";
          };
          HostHeaderValidation = true;
          SecureCookie = true;

          # Misc
          CSRFProtection = true;
          ClickjackingProtection = true;
        };

        Advanced = {
          RecheckOnCompletion = false;
          trackerPort = "9000";
          trackerPortForwarding = true;
        };

        Connection.ResolvePeerCountries = true;

        DynDNS = {
          Enabled = false;

          Service = "DynDNS";
          DomainName = "";
          Username = "";
          Password = "";
        };

        MailNotification = {
          enabled = false;

          email = "";
          username = "";
          password = "";

          req_auth = true;
          req_ssl = false;

          smtp_server = "";
          sender = "";
        };

        Scheduler = {
          days = "EveryDay";
          end_time = "@Variant(\\0\\0\\0\\xf\\x4J\\xa2\\0)";
          start_time = "@Variant(\\0\\0\\0\\xf\\x1\\xb7t\\0)";
        };
      };

      LegalNotice.Accepted = true;
      Meta.MigrationVersion = "8";
    };
  };
}
