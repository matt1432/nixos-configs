pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:739405742a79bd7447227c553bb62ed5491aa36acf00bc667af7f9c93b6fae91";
  hash = "sha256-pgUYxWdpi6Dn+1W0IDWGQoyTOLtFZ+w13ImI3u2tuRE=";
  finalImageName = imageName;
  finalImageTag = "release";
}
