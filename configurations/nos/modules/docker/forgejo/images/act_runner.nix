pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:dd1c4c2a361794fd22de1faf78357b236193172f8824093a0e31fa8038e16a41";
  hash = "sha256-XFcgllNndjMr35Z6oLQCumHZJqVgdoUITzTNSY0oh8M=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
