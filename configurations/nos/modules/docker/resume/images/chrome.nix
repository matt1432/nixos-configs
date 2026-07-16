pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "chromedp/headless-shell";
  imageDigest = "sha256:7f8ec4782f1b138c30900e65ae53795d5966fbf52168b8fc062843db3e6d5be5";
  hash = "sha256-h0qqAW905m/vzkSOpFMsFYxzBmi/E2Lfol2ra1Q3izQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
