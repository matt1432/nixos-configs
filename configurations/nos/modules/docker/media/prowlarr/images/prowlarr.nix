pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:d089b21e8ab2584b7e1713bde5d5f0160d7c9e850ceb2db53158a85ad3caac57";
  hash = "sha256-KCgL7eZopgGT14hysqF6vcAfunrSxJelNZAb+cW0kFE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
