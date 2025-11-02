pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:2c951a4063b55ec2de197fdf6a85e32b05872d3a18a18eaf851b827ff2622814";
  hash = "sha256-Nrl7NUQmE7ETOLN52wH05NZ0ODAKrqp1H7w6FHMMhoM=";
  finalImageName = imageName;
  finalImageTag = "release";
}
