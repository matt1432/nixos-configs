pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:58e3c049abc0bed4f85db6cac3e1490d718db267ae36bf56b2e36189e2947d4a";
  hash = "sha256-G/SdxlSDt7FDGCcT+aCrnG5P8p5hnZM4wsXLQizSSHo=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
