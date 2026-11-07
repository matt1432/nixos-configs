{...}: {
  services.ntfy-sh = {
    enable = true;

    settings = {
      base-url = "https://ntfy.nelim.org";
      # Only reachable through the local Caddy, which runs on the active node
      listen-http = "127.0.0.1:2586";
      behind-proxy = true;

      cache-duration = "72h";

      # Tailnet only, so any device on it can publish and subscribe
      auth-default-access = "read-write";
      enable-signup = false;
      enable-login = false;
    };
  };
}
