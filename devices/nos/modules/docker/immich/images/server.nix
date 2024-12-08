pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:1c887847b62490ce36fc5bf26b838282eed057d06168f6077f71f9a28ed63850";
  sha256 = "16wjgr2d9mg7d4x242762lhmwp5440y8zc3cklx87zqnzwmvixxx";
  finalImageName = imageName;
  finalImageTag = "release";
}
