pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:0463a96ac74b84a8a1b27f3d1f4ae5d1a70ea823219394e131f5bf3536674419";
  sha256 = "07jq312vccjpiw5x4h7ahsgdfigxj41acp218n8qfba26a5mcisd";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
