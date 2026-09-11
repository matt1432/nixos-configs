pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:84b6f05a7a4194fafe5a0bec062d32f6ae9ea74db33d43d678cb9a3191f31c24";
  hash = "sha256-P11Sk/Cl3lB2KtOmuNeigSRjTVycgWOtRHzZoAZV1Y4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
