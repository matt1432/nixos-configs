pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "cyfershepard/jellystat";
  imageDigest = "sha256:e61c759ec706da378bc8374e797da1dfd298ab30f804cefd82d192c301a888c7";
  hash = "sha256-VQIxSxGxtRiLimyQLZ8cOEdO0RzLEb4fLqICO1Sx/3Q=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
