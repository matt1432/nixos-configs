pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:4fe17f415f90087377d37c755e0ea3cf189dcc6794e49cdd2a9adbb4937d9e1f";
  hash = "sha256-fzhIWgCIp+hvPY6OJ6AfdAJpyq2WrIFdrYaq54sAAGg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
