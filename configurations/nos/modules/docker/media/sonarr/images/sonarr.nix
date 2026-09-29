pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:f247545d23ba8b233d6604575347e48a623fe6ad75dda02348bf81917f3b5c06";
  hash = "sha256-gAsW1bJZUxVxcg6pex9Iu1LqSI7LwVq+vP3xm8Yk+84=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
