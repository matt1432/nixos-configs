pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:73ecb0235fd8038365668c79c914cbc97132f1c38f47848546ab687ac27fc5cd";
  hash = "sha256-w+yA9HRZ4kb/KTLsv/I5ZN54luQEO4EsJzLx31qp9aU=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
