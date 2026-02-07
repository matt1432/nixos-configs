pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:c92a23eb45ce6813260c5f24501e793ed04d2a9fade3ad0b2801dfc86b786c32";
  hash = "sha256-KoZOcMtexNZLu2umsjOsRyaKNYBK2VXgcUb0Mhz1+Vk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
