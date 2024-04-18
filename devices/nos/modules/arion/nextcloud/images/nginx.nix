pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:d2cb0992f098fb075674730da5e1c6cccdd4890516e448a1db96e0245c1b7fca";
  sha256 = "07jq312vccjpiw5x4h7ahsgdfigxj41acp218n8qfba26a5mcisd";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
