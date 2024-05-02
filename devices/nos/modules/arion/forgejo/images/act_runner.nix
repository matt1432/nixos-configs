pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:d86532849bc0a790f6d16b153c6885f96be1791deae00967a6a0caddf9eb40eb";
  sha256 = "1c0ww2md56bjlmxrpqqys5vskycj25z9pandbv64jpikwphkj9zd";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
