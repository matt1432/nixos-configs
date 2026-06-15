pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:608a100c71651bf5b773c89083b4a1ad7ef4b2bd05d7a7e552271e03123692ad";
  hash = "sha256-lqnr6m1g1ANIMq7Ia9WAT0HrmUIppHdEAwPolTzybf4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
