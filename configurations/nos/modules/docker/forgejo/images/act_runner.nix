pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:52c2b212653b250add8042406054f345525bf14f9c89c255c7caf8abb8215482";
  hash = "sha256-2+tY+nmHGxuqyKXappP01kmtwCCYROO52E2iLMbShJo=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
