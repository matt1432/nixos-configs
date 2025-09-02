pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:eb4f0833816c0e86a666dc8b78273facf91e59a703271445d9525d3c413bb94d";
  hash = "sha256-eEpSQderO3OxWKLsx2nh3JtNRdhj16nMZpptIVIL1K4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
