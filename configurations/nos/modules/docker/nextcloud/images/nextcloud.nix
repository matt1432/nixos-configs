pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:aeb04735a4ef015560e88bb18a5dca7ef1e58f28b43665ed1d37bccee04b2699";
  hash = "sha256-3Is6mpetV/Tq4Z+bpstJLjbe8G7/3LZUNYzcwmHX8hA=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
