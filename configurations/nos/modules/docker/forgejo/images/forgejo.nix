pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:8f4b1f86750e206824c669e1af17b6c6e8da9ed1a8ebda615db7526ee86d3eb2";
  hash = "sha256-F9aG3lTPTWgBKiHwoHOx6X/6jgQtJR48zjalvAFtsVA=";
  finalImageName = imageName;
  finalImageTag = "14";
}
