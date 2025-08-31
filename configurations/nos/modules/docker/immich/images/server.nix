pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:92effed36e8fd55dc46e3f50cf891fd12f8f5429aaf646ef99fee938bb1e38af";
  hash = "sha256-euuaWani9DLprSwHMcVQTO4aOcKAhVhMEmJw5tfKelM=";
  finalImageName = imageName;
  finalImageTag = "release";
}
