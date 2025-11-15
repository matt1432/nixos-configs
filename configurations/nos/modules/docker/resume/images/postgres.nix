pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:79c06d285ed9186efbbc45c73413b3c3510c3c94ffede2f25d1e523f74d07f28";
  hash = "sha256-q5xIJeUhEr/nnk/joMbwr2L8N8Hu/q1J2+yEUXpnv6M=";
  finalImageName = imageName;
  finalImageTag = "16-alpine";
}
