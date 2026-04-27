pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:acf1aa9dc09c78670c5729bf41ea611b97a37f088933e1b40a42004bf5c8b3c5";
  hash = "sha256-SmY9PHzykpBgvIl65WEuRb6+vrbtkAkc+hb/4i0S/9U=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
