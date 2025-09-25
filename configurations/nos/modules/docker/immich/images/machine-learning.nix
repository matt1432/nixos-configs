pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:cc94659771d7e394d6406ebb0664069f2523062fda4f934def31648e903c4de2";
  hash = "sha256-wUFS2ajQtiKCRJdC5/VTzqUiI+HdYGc9xdzfVWEP958=";
  finalImageName = imageName;
  finalImageTag = "release";
}
