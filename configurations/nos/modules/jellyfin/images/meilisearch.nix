pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:348ba1c1f61101130304370a9522cc5405e6906b64a426dc2fcd5c428a516a98";
  hash = "sha256-DtrR9sWl2NPkQOWwUv754I6kYLN4hCVjs5S9aH/JTjk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
