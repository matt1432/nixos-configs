{...}: {
  imports = [
    ./blocky.nix
    ./caddy
    ./headscale
    ./nfs-client.nix
    ./pcsd.nix
    ./unbound.nix
  ];
}
