pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:7563f01bf27554df58e10544a4bb83479258883315a31cd1c929293e908144d0";
  hash = "sha256-nvBl0qsU73+kYbncmGWr749WgE8oxm9IHKfS8zvkKJc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
