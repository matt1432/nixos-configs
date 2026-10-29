{...}: {
  services.anubis.instances."forgejo".settings = {
    TARGET = "http://10.0.0.121:3000";
    SERVE_ROBOTS_TXT = true;
  };

  # Access to the unix socket
  users.users.caddy.extraGroups = ["anubis"];

  # For accurate stack trace
  _file = ./default.nix;
}
