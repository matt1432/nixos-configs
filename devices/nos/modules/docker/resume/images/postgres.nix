pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:fd3abc9557df27613bd5c5e6608fc62fb04dc90c8e79c3322348d600e4b75478";
  sha256 = "1y5y3bvswpbacqmcrilw8c51ksw4vl5q2ldb05yx8947p7sgd238";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
