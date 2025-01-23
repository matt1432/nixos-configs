pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:9a7fdfb1679017ce853e5ef9d7280744a98369c72ff17a90957ae3cc68a1985a";
  hash = "sha256-TORLTxtzk9e9CnGqxEU8CFgZalvuBuqKT/PqnOigxaM=";
  finalImageName = imageName;
  finalImageTag = "release";
}
