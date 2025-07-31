pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:911483a9ec04de93e60e649a101eabab5d7c143bcb14fcddb32161d34016e11b";
  hash = "sha256-rmMlO9nEy0XtClshRwf/eM7N3WPYwOcJnGQgemMXnWw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
