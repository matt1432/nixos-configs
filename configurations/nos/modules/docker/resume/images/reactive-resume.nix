pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "amruthpillai/reactive-resume";
  imageDigest = "sha256:f26fd329f35b97bccdf5ee5a7b558df0ccf1e073a1d7a5787e433043e22b9296";
  hash = "sha256-bQDmfFf3t4Oo+502IqLIK3GUNnpOA7IjmhuRLaYTvzY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
