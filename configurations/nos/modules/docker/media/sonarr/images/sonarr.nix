pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:ca4ad72f07e532d1d414435eb43193d1dc407255e46c21c2694653ca8af4fd81";
  hash = "sha256-TdsBz8lkZSjBrcHB2QVxa9sWKoI66HhjstGss2FkVZU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
