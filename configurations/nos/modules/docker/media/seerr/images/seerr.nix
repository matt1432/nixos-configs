pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/seerr-team/seerr";
  imageDigest = "sha256:27602401178d54f1964442287b9f23f67a3fa2252645ee8065839ea1c3f69e45";
  hash = "sha256-W1hdOqpG4KaPYtBhlO5jw+WIZTKZn0lqa+U6v/e8rlg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
