{...}: {
  imports = [
    ./blocky.nix
    ./caddy
    ./headscale
    ./nfs-client.nix
    ./pcsd.nix
    ./searxng
    ./unbound.nix
  ];
}
