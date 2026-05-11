pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker";
  imageDigest = "sha256:685b91dca8eab7de1dce1c303dbb7a763e4082d6a60db10968adf3295fbd2495";
  hash = "sha256-RNlGB3By+ozUhotX495Zu87+6odD/9FCjuHjwE9ezro=";
  finalImageName = imageName;
  finalImageTag = "dind";
}
