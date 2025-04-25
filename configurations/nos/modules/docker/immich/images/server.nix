pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:71cb6d2a6587f6481ae22b1cd743c74f163acbf26ade4df890e4425bb1f2e891";
  hash = "sha256-M/t9NcZGRitWM9+rHiFjd8PreKqnW2EsHD1rS+nBH6M=";
  finalImageName = imageName;
  finalImageTag = "release";
}
