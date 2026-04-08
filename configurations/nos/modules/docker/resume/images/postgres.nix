pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:ddbc320a9ad558c01c719248108e607eadde92fea799fec799028cfb2fab7319";
  hash = "sha256-sv8Q1Sz6e2GsqgwEkzjloWeU98Hdy+VV1BEa/ErjsFc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
