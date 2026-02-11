pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:18ff732dffcebd559d15a91845fc3360d49652ea01dccfbfd98b8248ceb86e38";
  hash = "sha256-ei2gllcbbUo76T8B7RQ1vd7D/BvgCFMPHVC1FvAPx2A=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
