pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:730d710941c4cc48039d8533efc3222d16d36a46504af3faf8978592f0238bc0";
  sha256 = "0nc8xbv3kml2ld5983r9qml82q97lb6wr7h1a2akl5kbdsxirdj5";
  finalImageName = "ghcr.io/fallenbagel/jellyseerr";
  finalImageTag = "develop";
}
