pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:81d76b6c13a7a9481440402f0fa0ff1dc6027d003447da28eb1ed150e1846af7";
  hash = "sha256-s3/OC/a6uUBZsXFJlTojwdvhdnatUHWVsmXPiAoh2qc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
