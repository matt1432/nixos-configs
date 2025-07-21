pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:ae89f05ad7023258730ed62f5fcca63aab1e27ee5adcca1edb55d716f7cef356";
  hash = "sha256-f+yqHnvU0JEC2WEW+AI/7doPPGyIO07SAahDYJwklZg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
