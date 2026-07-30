pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:ebdfe70701c60ac0c28c697e787cea767d7972940b786037b29fe0d507f821e8";
  hash = "sha256-TzSepKz9MJDH+TtaeZ7E2VOqhuztuRz4wPXES9WYld8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
