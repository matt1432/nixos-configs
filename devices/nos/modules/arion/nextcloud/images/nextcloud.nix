pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:43c6307906f65f17d6b22d01d25f7024700f2affa774ae7128c882f0276bf772";
  sha256 = "0lmhq6bw730jcz1gv1wn5zcfqi3vr3zlvnfpqqwv5zl6fg9kppl4";
  finalImageName = "nextcloud";
  finalImageTag = "29.0.3-fpm";
}
