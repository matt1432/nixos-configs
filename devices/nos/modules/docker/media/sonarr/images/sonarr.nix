pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:28cc44346fc87805b52a4376a89edc12cf082a5530cffee800a6c05dee482734";
  sha256 = "0yr58w8hpshnkw8ww63ld8alhf5lnn7zibm2sh6qpahz3q0x1zsm";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
