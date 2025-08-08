pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:bbb8aa45e55a17c7f6c0a951c32182e76b3097e7517dbd08956e437b55625563";
  hash = "sha256-qPWJKr6Zy879hxfBRXnHgvQJibuYFaoJFmv8/gO9Htw=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
