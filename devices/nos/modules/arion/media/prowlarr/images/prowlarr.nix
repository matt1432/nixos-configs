pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:3061e68afda543202ee7382cbfe3bfa94a1ab7d03ebaa242c732ffe2f73088f0";
  sha256 = "035jk818vg9znnjhx1qfaj2ay6h4d2snzbli7pa96l7ccyf2r8j4";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
