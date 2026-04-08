pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:c61459858524e53657e40a5b5a05e1a5dd0593d297ef67b49996c34cbdeb61c4";
  hash = "sha256-g7NJgcZ8n9ipqwq8dKoHDL8EV2vb71XYkI+6eqi8gQo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
