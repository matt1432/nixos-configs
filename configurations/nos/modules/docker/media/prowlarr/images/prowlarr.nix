pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:6df73ab9e99d0dbaad27c39d8a47c600333eebea80fcb56253a0bb8b630c8115";
  hash = "sha256-F2WI4cCRmPLHQh8g1E4QurA5HGMwriX9l4pym7ladsQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
