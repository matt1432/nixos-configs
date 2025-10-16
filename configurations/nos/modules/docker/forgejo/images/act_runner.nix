pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:c15dc74aeef4ad7bda5ff4ec8332e00e33f47f273569a52703367b0235020338";
  hash = "sha256-rqLJSMXN99v7NEpnT32X1pyskCNVd2YyErO1PP5jteU=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
