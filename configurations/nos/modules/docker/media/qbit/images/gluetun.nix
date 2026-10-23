pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:c2ee4191762fca6b6a3c3359a731198a95d9c9af4db32d466e223bf3a84e779b";
  hash = "sha256-pFPtIKq2zJ8yRUawdUERIpwfDCQ5ngdNkVukXJll3I0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
