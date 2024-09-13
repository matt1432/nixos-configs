pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:c1318191d5211ac7462c754422eafe350ed0de61c4160065a420896068ec1ccc";
  sha256 = "1ddvrlh24x0blk1vkvxvxwi9hv4hqagy8fd4183vvpcf3c1rfpps";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
