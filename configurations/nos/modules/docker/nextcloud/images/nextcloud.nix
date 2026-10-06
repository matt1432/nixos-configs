pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:413619a84235de613b9fa1dc9428d366ffdf124a489981d72f38e5ebbcbae2db";
  hash = "sha256-dvLrgOy+ETZ7NMNqZC4z4OiATaXzlpsKTtKBn96W2WM=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
