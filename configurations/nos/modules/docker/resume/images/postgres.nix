pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:987b242173006d6df08506f10b967a71478a3610664cfefbc49b9c775d3d0eed";
  hash = "sha256-iTOySi9ziEc5DSwIirdYwt7mg36AyZdHV4I3WqF5AQc=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
