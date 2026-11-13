pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:832820dec70bce9e912c6eee7a95baf6551e03dbc63325a7208daaa455423752";
  hash = "sha256-lvXUFr4NoFN6mOh1efotrrs5rAb41JurEybM6nUsmIc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
