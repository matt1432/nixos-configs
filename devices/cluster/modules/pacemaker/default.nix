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
        virtualIps = [
          {
            id = "main";
            interface = "eno1";
            ip = "10.0.0.130";
          }
        ];
      };
    };
  };
}
