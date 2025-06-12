pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:1e729d43a0d16c02640dab2f99db1753d3b1d217cde347f39a33e8d58fde44c6";
  hash = "sha256-TdKQr7B5slT6ddw448GlNklldTIidLvS5tldWW65whE=";
  finalImageName = imageName;
  finalImageTag = "14";
}
