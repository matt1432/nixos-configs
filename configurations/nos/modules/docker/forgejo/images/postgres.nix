pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:84dee213c689b6dfcc0e2692ddd66adcd7314057175ea7aa05500c527e0f807a";
  hash = "sha256-ZojtW6DMB0rsW1ywVdSg26S727ru2S5o/dsC50RKmOE=";
  finalImageName = imageName;
  finalImageTag = "14";
}
