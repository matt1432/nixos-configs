pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:d38705cdebe2389b46e11d46b7874ffb81d7e7bbf68eaa02df6f26b97d550901";
  hash = "sha256-zOnbIueHJgv1CgC1ajRZBU0rkkCm5E33k0ne+jwIE0o=";
  finalImageName = imageName;
  finalImageTag = "release";
}
