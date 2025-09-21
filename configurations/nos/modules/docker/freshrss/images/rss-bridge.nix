pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:b0b56ac588a13567815fa1248d523dae6e2447278b48a35228a202e8db5b6885";
  hash = "sha256-2YlCLWtK1xNcx9nsG7CBqcJBM5zefxK/D9sUI4rcOiU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
