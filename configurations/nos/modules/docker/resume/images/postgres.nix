pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:52e6ffd11fddd081ae63880b635b2a61c14008c17fc98cdc7ce5472265516dd0";
  hash = "sha256-sv8Q1Sz6e2GsqgwEkzjloWeU98Hdy+VV1BEa/ErjsFc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
