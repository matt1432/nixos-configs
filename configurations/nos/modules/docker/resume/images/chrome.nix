pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/browserless/chromium";
  imageDigest = "sha256:75928b6ce72502be734f4dd9573917b06d28c30117e0eb260c52a53b47dc5e07";
  hash = "sha256-W6Mdn7l4pI4y+v6az3HaAQsPdsBn5j5s7OPkbZq2nVQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
