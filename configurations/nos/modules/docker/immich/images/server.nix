pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:1d303559b4c7c6b4ea3cea2276279e4cafdf605c624625674924a6ac04f263cb";
  hash = "sha256-Pz0hcKUFCKeDSmZOoQUFb2AabDNCTSpxMBplX5nJDdQ=";
  finalImageName = imageName;
  finalImageTag = "release";
}
