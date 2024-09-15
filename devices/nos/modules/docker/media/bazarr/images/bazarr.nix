pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:476c315f0381d0b8c7921fbf3116b65e96ae32128df5fd27600e97213b862809";
  sha256 = "0c59zsddmp8din5c516zhcsxfjx6a5w0yam7ynavsa227cjxa0m5";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
