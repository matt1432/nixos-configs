pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:85f625a5b4ca3ace206cdbefb0c111e2feaa110f4cd64489463bb36d75713490";
  sha256 = "1b7vflw19bg4i7mf108hp4g3z45kc8qrdmbsfxmrljs4788wqc7w";
  finalImageName = "nextcloud";
  finalImageTag = "29.0.1-fpm";
}
