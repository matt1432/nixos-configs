pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:6a388fba16e2a94d6d92bc3c435cdc2e20145add88547615b3d8fa545d703afe";
  hash = "sha256-SWhSToPRB4OF3CXlimeWswOR4jO4mWGQEkiIs/z/2/o=";
  finalImageName = imageName;
  finalImageTag = "16-alpine";
}
