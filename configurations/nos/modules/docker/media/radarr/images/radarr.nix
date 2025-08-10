pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:c2adf66bafefa781401d07d358e399c476bdffb9a179a2780bb465bda8a55a51";
  hash = "sha256-j9NratpfQs2IJGMrVljPGcG1F5fVTZnJwWzQO4eOfhc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
