pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:030b54decbe81f56e35916726adde03cc626080c44ea7acf41ff7a72a6364115";
  sha256 = "1yv1s79z79zqjffq7pg9j68y8d1dpaxns11cphbs38pdm8ij6ks5";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
