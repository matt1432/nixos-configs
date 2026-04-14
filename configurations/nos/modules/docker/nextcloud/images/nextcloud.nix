pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:e31c86e7b68e5c6616e5d35c6b025107df4d26720414a51ba5fff925656196d2";
  hash = "sha256-aI/x/sF16IKqDzyvOSzFKTRREZW8qjfOWq0Mh/FOCSE=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
