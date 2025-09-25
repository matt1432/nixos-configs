pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:a5935f03b93137952c38b14a47148525023f4c36a2db174d8266a9d3b37e7e3b";
  hash = "sha256-Por92IDzg8bhJKNzLNUy67KHuQnvJwKmbU6sOz4rI9Y=";
  finalImageName = imageName;
  finalImageTag = "release";
}
