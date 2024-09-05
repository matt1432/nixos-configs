{...}: {
  imports = [
    ./blocky.nix
    ./caddy.nix
    ./headscale
    ./nfs-client.nix
    ./pcsd.nix
    ./unbound.nix
  ];
}
