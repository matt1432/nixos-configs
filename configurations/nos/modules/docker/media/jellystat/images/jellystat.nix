pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "cyfershepard/jellystat";
  imageDigest = "sha256:3cb35f261ae2581e90c64e00a5a310247cd886832e7ccd71f79a6205963de44e";
  hash = "sha256-Tah5gZEgIiLHrr0gEqHT67uj9sCFss/QnZcHWpyMdTQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
