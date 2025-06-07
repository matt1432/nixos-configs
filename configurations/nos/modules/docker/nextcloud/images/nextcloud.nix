pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:8423d66227934466abc95904d2b542cb4fea6fc6065dfa51d27cb180a36f430c";
  hash = "sha256-dq1PFg2eiRRkeF8KrL+GjjiK8TbgRtfboPt46qORR8M=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
