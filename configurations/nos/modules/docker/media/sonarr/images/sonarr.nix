pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:e6c9a091735fede0c2a205c69e7d4c2f0188eaf2bec7e42d8a26c017e5f2a910";
  hash = "sha256-8SsP1FJ7dRYKHVvvcT+x9w2WR/0UQ2QBXdRqJSz70ac=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
