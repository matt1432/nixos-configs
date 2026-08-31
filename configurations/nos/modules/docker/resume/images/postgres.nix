pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:4ef4dbc939d61acea57712655ddb4b4ab27419c913f94cca0cd57cb3ea3c2280";
  hash = "sha256-bw0wGLh+YQyi6G6hbwDqfxLqoV4JvVAV0Bo8FJfL9FQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
