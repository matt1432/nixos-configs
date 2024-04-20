pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:bd8300efeade567181252ced1a76d386473cfd2a40aaf0b56f19f1771a359632";
  sha256 = "0w0c13jiz30idbpbkp547p1icc2w58x98614vw9hqlrk0sfpv7b5";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.102.0";
}
