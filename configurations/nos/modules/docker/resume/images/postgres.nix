pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:2971a22cacaa39b2107e328fb31da85311aa02c91ebbebb39b3987d58bb019dd";
  hash = "sha256-iTOySi9ziEc5DSwIirdYwt7mg36AyZdHV4I3WqF5AQc=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
