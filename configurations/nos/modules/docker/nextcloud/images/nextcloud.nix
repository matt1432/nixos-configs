pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:1ab9b3d72f0f239e4caf52f47019586a7ab431bf22ed6a4d2b499e04bbe8e268";
  hash = "sha256-jdJWWyYkPupyXCbsks1SqEi6+4DjAQiWXAXwkP27saw=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
