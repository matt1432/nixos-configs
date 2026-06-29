pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:3950b5e48cf4ba9dab78fe14038dd7f062e66b7b4ab368b02c94a13f6a3dae9f";
  hash = "sha256-yHqFkvAcj5r2oWgutLpXNcXv6CgFMY0L/u3H/e6eR38=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
