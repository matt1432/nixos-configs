pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:013c654110a029e35b5701851e837fa59627b80c91232af04f6aea63e0cf5aec";
  hash = "sha256-ZSXevwptTxxXnaJOikifGVj+iJr+RF5BGz3BM8wVOAs=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
