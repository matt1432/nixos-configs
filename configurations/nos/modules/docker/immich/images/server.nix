pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:06bc7715fa4c4a1641bd0b566c949cd7327f420632b480389fd4d1e70665d046";
  hash = "sha256-mt7ucTKA0GevRj016dLufLrn6XWLM+tcO0Cd4wVON8o=";
  finalImageName = imageName;
  finalImageTag = "release";
}
