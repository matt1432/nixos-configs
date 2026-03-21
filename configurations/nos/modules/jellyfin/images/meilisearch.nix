pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:52b60339c068245fc0660242fcbd5822c5984c033eea044e1d2d8cb3f01ea470";
  hash = "sha256-T9gU4vYHJO14XRs9lUtVKCpBI5EcwTOWNlBfp4lxMqE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
