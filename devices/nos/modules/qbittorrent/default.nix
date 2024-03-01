{...}: {
  imports = [
    ./qbittorrent.nix
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
  };
}
