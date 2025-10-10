pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:005f97fcab0fd7402cd7ff3c09f5ff4da4c63ca51be487e90d5c4dc8a8f85a45";
  hash = "sha256-aA52sFGMMJrbClYetgrEbvyeLzT44IxFw708xXomioU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
