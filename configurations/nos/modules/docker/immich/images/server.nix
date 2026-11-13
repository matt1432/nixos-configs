pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:7c489add298fc2f92cda4c777de6462aa206877e04087b815f62c7664af0b53b";
  hash = "sha256-mvGL1GoCFV+p18kaxXseB63/8u0fEmvOntoqGpHXOHg=";
  finalImageName = imageName;
  finalImageTag = "release";
}
