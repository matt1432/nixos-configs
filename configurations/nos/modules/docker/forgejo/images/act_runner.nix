pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:e4e403c6d197b86f7421c64d682b0e8b766e3703989449930cdaaec82ea82216";
  hash = "sha256-OWz/9c46zgCdLCPPFU3dx9TNqcnvyRn7CN8vyGonbRg=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
