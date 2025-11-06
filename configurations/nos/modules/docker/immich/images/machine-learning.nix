pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:bf339cbb44af6c2ef25d9128e1da51b2bec0cfd524846a83e3017c21bd71ddb4";
  hash = "sha256-+Hag6G55UBvgUzuaYNW1CHsjm+1NG3FiuB9JLVjO4BI=";
  finalImageName = imageName;
  finalImageTag = "release";
}
