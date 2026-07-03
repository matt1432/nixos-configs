pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:46dedfc5848f7313bd6b584ea9f2648057430307aad6de56de968f6710a72cae";
  hash = "sha256-ZuR445Qqpuey23VdOf4Tz5yQzjYs3fYdLLnoaiKuTDg=";
  finalImageName = imageName;
  finalImageTag = "release";
}
