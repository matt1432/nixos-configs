pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:366914352b21e79733f1bad1c3840ca679a55dc4875754eec06ccbcc49b649d1";
  hash = "sha256-rdYRsvbtTyEGpJNjs2nGKUm2mmlOa9UUzBr8uYttmNs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
