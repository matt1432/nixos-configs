pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:b666479159c0ffc17d5c2281737c9a88d78afcaa0aa52cb441b46336f6feba31";
  hash = "sha256-SXIAr0N/wu/ElvSpLcmo6xq7I5D4c+v0ZefV0aMv5Zw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
