pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:2a8d95df824eb5a9721460dd8419384c81ab7b8eca06b5ea65785e3fbdd87f3a";
  sha256 = "136y93aaypd936jb0j82qm0dpp3an2s6q8xdxvmp8rlpgbmqj5lg";
  finalImageName = "nextcloud";
  finalImageTag = "28.0.4-fpm";
}
