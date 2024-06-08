pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:60b34beeb8f549437400744c05c9c2ae4520db16fbb9941d347a4dfe9783ca8d";
  sha256 = "1ad3v72zcn6w2mnm4vggfbhbkc510s717s8hr8idbvnk9iqcawlk";
  finalImageName = "nextcloud";
  finalImageTag = "29.0.1-fpm";
}
