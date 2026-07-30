pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:5a0839dc5303cd7215bcd2180a26aed3af41675aefb3e75e5157e9f10ad16e6e";
  hash = "sha256-M1PrtJzRC7580a2YR8D3rFEDm9hMuRGgRn7gv7/bbTs=";
  finalImageName = imageName;
  finalImageTag = "release";
}
