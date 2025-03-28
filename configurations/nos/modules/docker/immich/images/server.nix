pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:eb5e28de53461e9c328d86fdccfddde579cf9b10ebb3105a2a194115b79ad8a9";
  hash = "sha256-Et+AzxtIt7UqT5AI206D5Pp1A9eb56hZmNbdEvJ16Y0=";
  finalImageName = imageName;
  finalImageTag = "release";
}
