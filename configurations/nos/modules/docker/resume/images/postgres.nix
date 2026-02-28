pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:69e8582b781cb44fa4557b98ed586fe68361e320d9b12f9707494335634f4f3d";
  hash = "sha256-Ul9y4jfYp8MTB+1lhIJK5j2qTHlKAl8GovwqcvSHW+c=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
