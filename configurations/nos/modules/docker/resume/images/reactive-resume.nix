pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:656a7ce0409ea1b8fcdb4985320d8b687b94da1201d10af13fd1e2c7c74f6083";
  hash = "sha256-LFE2UzUT9hrTu3VD06zTl4Bug+VL887kDPLPRsQyhxc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
