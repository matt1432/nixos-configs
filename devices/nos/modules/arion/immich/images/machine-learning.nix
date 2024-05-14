pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:2e2736ba2f2270485c0b6fa33eee66ea0b2279b70b92ea838a015c4d5289c9f0";
  sha256 = "07kbzm9147v90hxa97xcf2fx4k40wdby7x06i18pn6dn8anqsdld";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.105.1";
}
