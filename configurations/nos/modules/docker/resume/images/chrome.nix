pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "chromedp/headless-shell";
  imageDigest = "sha256:313ed7255ae1e155fb157631a6d4c0eb8b65bbe06de9e704ed834399bdf678ff";
  hash = "sha256-zYw/3ZWwkb+0yCrvwY0sv/8Vs51z0hOeMtFAQBgyVQs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
