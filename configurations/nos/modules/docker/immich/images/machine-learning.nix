pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:9f2f61d86af82d04926f9b896c995c502303052905517c5485dd26bf1e42a44e";
  hash = "sha256-YFjYgADPegI65cTtJ/JZ0N9O5ejenje6f1eVnIyFS6U=";
  finalImageName = imageName;
  finalImageTag = "release";
}
