pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:a65ccb53a22b048e55412c989d0aac28a6e37839da410286aa098cad0d322fa8";
  hash = "sha256-w+yA9HRZ4kb/KTLsv/I5ZN54luQEO4EsJzLx31qp9aU=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
