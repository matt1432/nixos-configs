pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:88ad5957e747ddceb7641b072c22a0fbf85fe3b7ca9fc63a871d72b14e5d0ae1";
  sha256 = "1mhn675qz5ymn1vsy14y4md9qnzmicpvhplnwl90mzwf3c1jvq3a";
  finalImageName = "nextcloud";
  finalImageTag = "fpm";
}
