pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/wg-easy/wg-easy";
  imageDigest = "sha256:24eddefd4e5ae2cff930d4f9254f018d5f4cdd48daf559e7a73a14da6a9fbbb4";
  sha256 = "02j61zn3fqkxj5pjllf9dk8209x1wm8m8ng38b5g7x7bl7h53gc4";
  finalImageName = "ghcr.io/wg-easy/wg-easy";
  finalImageTag = "latest";
}
