pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:de8ac87d29421127b51259c11b3ff7b3152648c9c5785ab0bdaa0aa57493d18d";
  hash = "sha256-EAQ2L8pZPxcOjUuKBGNpNECUy48KVX0ZvE3XD/PEc5Y=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
