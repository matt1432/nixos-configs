pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "cyfershepard/jellystat";
  imageDigest = "sha256:c4e2dfa8bddf8d5ac3a675d7202f71a54dcfe3540cc186899d9201e0fe701fa5";
  hash = "sha256-+O72Zulfw78JtyS8MsSwT9yq0Rw4j7cM1iV+nhzd7IA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
