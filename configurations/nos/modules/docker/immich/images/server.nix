pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:485d546a2e31d6a8b4db8423fcba5c109de8c218d93410af115fd1ccfc4352a6";
  hash = "sha256-N6SATl1sTusBmszdYzxxLAaZdu3S6y3jQpxsL3gDFEE=";
  finalImageName = imageName;
  finalImageTag = "release";
}
