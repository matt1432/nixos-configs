pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "chromedp/headless-shell";
  imageDigest = "sha256:4ff0354582fe1de9926abd2e75a8d9562d19f786d2832b4e2197cb30bb89607d";
  hash = "sha256-Fil7i6VpOTKS9uwO3FG+BWyMqEqv6T3dhXF639WhMoE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
