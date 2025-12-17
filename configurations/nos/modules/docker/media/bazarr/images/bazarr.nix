pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:648f694532a3a53d8cf78bc888919ef538659bad41af4c680b0427ad1047d171";
  hash = "sha256-ELOleKELsnSYr4OaxEhQx+sWkFUAdEIpe0+us6ityQM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
