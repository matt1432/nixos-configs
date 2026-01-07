pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:3785c9b813985821c9b56ee88c516d96b37dc21242c8f315f52e87c029735695";
  hash = "sha256-z/eFvYzLI3Qg/IqBtvdoQss/MHwdBtT6rsSNeYr+qEE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
