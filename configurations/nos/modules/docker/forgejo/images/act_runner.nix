pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:ea3a776cd3d173a86afdaeedb90ea10fae3595d59f29e0f96a63d51a60213ad8";
  hash = "sha256-f3AorhMnA0GZiNq0UK3hIs+hyvh/LHrW3MyQugnvHFw=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
