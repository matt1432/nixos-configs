pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:33b17015c3d14f2565e9b8cd36b48a70027b14b5cd20da7fbfff21a370b0309c";
  hash = "sha256-zKuKfqRPygV0Xt9aQQZjSirWCelQMhi835/q6N+ECFk=";
  finalImageName = imageName;
  finalImageTag = "release";
}
