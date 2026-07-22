pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker";
  imageDigest = "sha256:bfec1f5159c63a81ca6fdedbd81404d2c0e16378ed0feec3bb3fbf3998847659";
  hash = "sha256-1ZNi+igbSzoiNykqTvK8qR60u3fTMM8TC0JOkmk4mJw=";
  finalImageName = imageName;
  finalImageTag = "dind";
}
