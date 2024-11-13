pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:99f97cb61cd1b49c23fbee46a0ed067f171970518d8834c7e8b2dd3ac0d39c63";
  sha256 = "1n2j8miqb8vqw762gbqw2l5fkgxrp8rzk9npxirpdylmrxlcfnnl";
  finalImageName = imageName;
  finalImageTag = "release";
}
