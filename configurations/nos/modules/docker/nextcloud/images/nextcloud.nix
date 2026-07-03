pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:4eb70728fafd09d1c192c940adb50495bd7ba47bbb807cc8970e4851b551dfd8";
  hash = "sha256-f8oZRMymK2j2RRTdTosb7uyA+b/9SsAiLfRRa8BhYbE=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
