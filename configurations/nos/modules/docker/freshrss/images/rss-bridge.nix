pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:151826f65ef50a6e349b19ea1ff4874f26afb82638321328eec9d7b850bac620";
  hash = "sha256-CsGW9yMW9tcgoun8mHtSGUw0/Uf8Hsj6+tyhAMyT5s8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
