pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:a30d870ae503e617e84909367c8f19096567ef60834fa8d81d86d17a13e50d1a";
  sha256 = "0bnkkd40j8bs2khzgjn8nf66ibbdbw6n889kpvsd2lx85xn371j4";
  finalImageName = imageName;
  finalImageTag = "latest";
}
