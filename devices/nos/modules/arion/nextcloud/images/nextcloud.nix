pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:48d1331618f781b65d2577c8f954993995c93d02201e5a32d5da2871920bc7c4";
  sha256 = "0lmhq6bw730jcz1gv1wn5zcfqi3vr3zlvnfpqqwv5zl6fg9kppl4";
  finalImageName = "nextcloud";
  finalImageTag = "29.0.3-fpm";
}
