{ ... }: {
  services = {
    tailscale = {
      enable = true;
      extraUpFlags = [
        "--login-server https://headscale.nelim.org"
        "--operator=matt"
      ];
    };
  };
}
