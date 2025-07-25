pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:84ec966e61a8c7846f509da7eb081c55c1d56817448728924a87ab32f12a72fb";
  hash = "sha256-uLLHDELnroOuZIEwPgZC3AAmq9oiT3NU0fbH85ktoos=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
