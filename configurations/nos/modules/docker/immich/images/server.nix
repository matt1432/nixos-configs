pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:6d48910532cb8e2bc85737e52a633c2e65eeb499f6307e106cd131c5778ec634";
  hash = "sha256-y/tipVk/CdVPLhgDmUv7AMtRPsX5hNJ/5fOo3vMTNcI=";
  finalImageName = imageName;
  finalImageTag = "release";
}
