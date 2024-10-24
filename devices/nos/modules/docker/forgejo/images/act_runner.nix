pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:fe6f44905830a17f404e9912e2c4fe2f4a2c47bb3ee35409da6476618cf9dab5";
  sha256 = "0jci209g7qqsqa1qi87fjj00q1yz8d4wj7gqsy4la8jjrkb23arg";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
