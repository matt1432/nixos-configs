pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:1090bc3a8ccfb0b55f78a494d76f8d603434f7e4553543d6e807bc7bd6bbd17f";
  hash = "sha256-X91YBlSLPRyibOOfBxy3oywYc/UyzC4aF+oiHZ6j6+4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
