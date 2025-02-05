pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:a58cec2ba7a60b4c08d51f2ca93c1ad65fbf96e75cf0c89b7c0d2684860d3bb3";
  hash = "sha256-U3TASqUWqsaqy+V3/RcwyfwVbefoCegDGkRlBC1jG5Y=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
