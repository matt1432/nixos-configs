pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:f45063889794008cfc02fcf9d359b55fe37d1f8ebaf89653c89e1dd0e876eb7d";
  hash = "sha256-+wfQue+miBX+gNtOgs/UTWBMt2lriJcAGwhnr6QWzK8=";
  finalImageName = imageName;
  finalImageTag = "release";
}
