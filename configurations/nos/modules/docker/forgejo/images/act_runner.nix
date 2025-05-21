pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:785090c3833593dd5b96374469a948960fdfe2c6328cfd9b57b135c80fcb6ebe";
  hash = "sha256-8g5kX5sC51JKbVpTtxDMhTEGqZ1+vQjRR0gQFFif1vU=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
