pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:be8d7925452ccc8e42f8dc43860c958c2659eedb320fe52451a1f859a4114c35";
  hash = "sha256-ACeIc2tkAztxFcyGnENlclYh8YdRl9+vTYDc8AJ8wD8=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
