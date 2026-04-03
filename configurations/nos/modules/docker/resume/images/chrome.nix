pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "chromedp/headless-shell";
  imageDigest = "sha256:54a95ab0e5364e672d36031be4dffb1ac8cb71d5a780620ae00a4b61e0765532";
  hash = "sha256-fUOPqIktCwLD3SdlhLmOxHuUA8LGG+HhMkVDDODaqoA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
