pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:6ac392040ac13fec3a401c5a334304a0ed97390c1d1728d8727ab0968f1db1dd";
  hash = "sha256-aI/x/sF16IKqDzyvOSzFKTRREZW8qjfOWq0Mh/FOCSE=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
