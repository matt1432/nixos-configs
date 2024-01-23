{...}: {
  imports = [
    ./options.nix
    ../corosync.nix

    ../caddy.nix
  ];

  # TODO: update script
  services.pacemaker = {
    enable = true;

    resources = {
      "caddy" = {
        enable = true;
        virtualIp = "10.0.0.130";
      };
    };
  };
}
