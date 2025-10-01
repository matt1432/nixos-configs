pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:6644f90a8633f49a0cf33a75c492eaa72b2848af8b7b1f4582bd8be22e4d82e2";
  hash = "sha256-jdJWWyYkPupyXCbsks1SqEi6+4DjAQiWXAXwkP27saw=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
