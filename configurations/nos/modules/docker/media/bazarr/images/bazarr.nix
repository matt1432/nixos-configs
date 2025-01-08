pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:972715e7a7f18e14c39f2d10e833c5a823d11528e4531d3a496351f170e135d1";
  hash = "sha256-lqna5pNdexmsl51CnFCkQYlPXM2ZASOZ3v4aqWJezS8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
