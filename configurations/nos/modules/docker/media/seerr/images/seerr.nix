pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/seerr-team/seerr";
  imageDigest = "sha256:1b5fc1ea825631d9d165364472663b817a4c58ef6aa1013f58d82c1570d7c866";
  hash = "sha256-FZsIdiz0zhTjAWxV0l1PfIvHQTz1kVImaNQSDMJsWUc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
