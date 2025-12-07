pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:3101839d4a1f4ff46e44cc67868864aadc4b0722fe7b52c77089ff2c3eff9399";
  hash = "sha256-WBA5mqA04VKlxhbRDasY6RXkFy0wOd/anOrInSphamY=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
