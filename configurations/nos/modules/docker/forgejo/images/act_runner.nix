pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:8720f3dfc2499b92d3220b44006314a0b2ae13cb589aab4de5adf765ea9403f2";
  hash = "sha256-4DN4Th2I9XL+ozD8I41dZeRJY8H8nlw2MhuXF71OOhw=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
