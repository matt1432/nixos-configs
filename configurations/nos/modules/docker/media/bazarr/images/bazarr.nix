pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:ac284d3fda9ee7da8b15197dc51f0d7a2a1da98549bee99a3d924d3e94a5e7ed";
  hash = "sha256-7p29ecijN/2fh8JZebf7VnCOV89dCmCi8CWDyCK4oOQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
