pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:062b02051873a101837543675b5b4601cba06b1972d22f4b7969adbde5a280e4";
  hash = "sha256-kunT47cvNjtBcTnmisiIeeEh2QcI9FToW0pWqJmTLYM=";
  finalImageName = imageName;
  finalImageTag = "14";
}
