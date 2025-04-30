pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:e79536bc479553954578470c005fa9b55d3b51602c9e9a81b1c9fcaf60f5e7e3";
  hash = "sha256-EAI7SRn+CwCmwvHAPv0mx1yYls+ZWUqVMNQC3EUDvVI=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
