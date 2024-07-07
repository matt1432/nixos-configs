pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre-web";
  imageDigest = "sha256:2de4ab91f2768c6db32d083a5935663fcc0eded1a67a4fdc2c1f705f7bb24d2d";
  sha256 = "02z2dscq6fdyra3y92zbswaqy8qdlzw62bb67x75ypn3a5s5rydj";
  finalImageName = "ghcr.io/linuxserver/calibre-web";
  finalImageTag = "latest";
}
