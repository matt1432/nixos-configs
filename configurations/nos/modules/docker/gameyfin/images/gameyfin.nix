pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "grimsi/gameyfin";
  imageDigest = "sha256:4dff49c47d8772de84176468c039281f7c35c4aa2f512fe8bba2343e07e5003d";
  hash = "sha256-eXYV9UETofs6Moak3yXUCHmz1fcCHaqDdvuDfWQo15o=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
