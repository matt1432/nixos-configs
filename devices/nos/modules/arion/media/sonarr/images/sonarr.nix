pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:7b0f3cd03b5cd606c7010557e36890b11f30c4ff1c683c07b60589b62e221d90";
  sha256 = "04rbas446fa43b5vxi6aj4d2vvfn4lsa277x5dykijn0hvwrbprd";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
