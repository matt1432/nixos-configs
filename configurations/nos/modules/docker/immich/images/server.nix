pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:a906a1daf4e82e9fa3e307cda55c46618fa9a639f7b417d13392795c7a1c3176";
  hash = "sha256-s5W8wKrZWbnPfeSYek92h5pPYMOmfckm14imh8D4KVw=";
  finalImageName = imageName;
  finalImageTag = "release";
}
