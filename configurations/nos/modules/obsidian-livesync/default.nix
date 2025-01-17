{config, ...}: {
  # The secret that is placed here must take the following form in the
  # unencrypted yaml for this to work as it's appended directly to the couchdb.ini
  # configuration via systemd Env statements. The username and password are the
  # user/pass in your livesync config in obsidian

  # obsidian: |
  #   [admins]
  #   yourusernamehere = yourpasswordhere

  sops.secrets.obsidian-livesync = {
    owner = config.services.couchdb.user;
    group = config.services.couchdb.group;
    mode = "440";
  };

  services.couchdb = {
    enable = true;

    bindAddress = "0.0.0.0";
    port = 5984;

    configFile = config.sops.secrets.obsidian-livesync.path;

    # https://github.com/vrtmrz/obsidian-livesync/blob/main/docs/setup_own_server.md#configure
    extraConfig = {
      chttpd = {
        enable_cors = true;
        max_http_request_size = "4294967296";
        require_valid_user = true;
      };

      chttpd_auth = {
        authentication_redirect = "/_utils/session.html";
        require_valid_user = true;
      };

      cors = {
        credentials = true;
        headers = "accept, authorization, content-type, origin, referer";
        max_age = "3600";
        methods = "GET,PUT,POST,HEAD,DELETE";
        origins = "app://obsidian.md, capacitor://localhost, http://localhost";
      };

      couchdb = {
        max_document_size = "50000000";
        single_node = true;
      };

      httpd = {
        WWW-Authenticate = "Basic realm=\"couchdb\"";
        enable_cors = true;
      };
    };
  };
}
