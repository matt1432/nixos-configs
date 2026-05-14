pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:4b7bb6d861c08bbf0c388b936ada8b2ba57669ca9974323f504e974577d19d63";
  hash = "sha256-Yt1CRRsYVHMBqnV3uYLMy9ZWycC0rmyuTBCKlSyd6yI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
