pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:1f7c844e1c723ba09411a31f9a3ef8f551e6d77c9ff4f200ef36b870e8c8a3d7";
  sha256 = "0mcanyy9hyvypvakyg4416w03r4qjxl4rpf9z6mbmbxi9xy7lgd4";
  finalImageName = imageName;
  finalImageTag = "8";
}
