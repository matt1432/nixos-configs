pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:48b082476a7034a342da4b411f26a9547455cfe430124b19a6d4df7a22e98037";
  hash = "sha256-fdHi94LP4E8hJYJO5MZOb4lPCs5EF/KOx68m1LAy65E=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
