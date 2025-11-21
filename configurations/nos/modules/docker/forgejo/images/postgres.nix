pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:ca25035f7e6f74552655a1c5e4a9eb21f85e9d316f1f70371f790ef70095dd58";
  hash = "sha256-KVskaiIc5gt63rW+aT7cv9YWjYK+nfCyIct8DWh+oAM=";
  finalImageName = imageName;
  finalImageTag = "14";
}
