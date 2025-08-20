pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:0c9ccd8c879b71785c3874f8bda5297f6992c301b09aa96ecbd4a3ecad713983";
  hash = "sha256-Nz6UADjHxFtPO7AFmB0BHRriHaF2U3/SXJQC3SPYUGI=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
