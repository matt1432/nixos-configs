pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:137f55b12859e7f6905c513d403ba80dfe3b2afe7fa892c891c1982996a114ba";
  sha256 = "18nlm339ji57rbmps1vbzni1c84j7k5ph9lxgs62396fal4rilg9";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
