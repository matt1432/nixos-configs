pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:c5f451323c61897c7920755d3dc93c5801ed8cec9d949952c59aeede510392d2";
  hash = "sha256-3HFKmvsWnbpupFjneIe/nfrUjCH/v5DqHWPx74vJwHI=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
