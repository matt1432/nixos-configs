pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:f14a2cadf5edb453849af5dc180fd22ddd4d3a1ae4ca1f3bb28cf287c88f7ecf";
  hash = "sha256-BvszHcFcToVAGOROrOh9AwxUdfnk1bWRg6DADetJJLE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
