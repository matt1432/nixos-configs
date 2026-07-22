pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:2f3d31307beba3ba2dd226d191f5f5c14ee3b4d8b49277c64683f5ed97083179";
  hash = "sha256-bW0F/x+EBGDT6yiX55EGiDMLMH50GzXa7HinAEjUgMY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
