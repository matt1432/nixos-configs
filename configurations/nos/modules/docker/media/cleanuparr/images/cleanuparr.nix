pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/cleanuparr/cleanuparr";
  imageDigest = "sha256:4093c0eb48c1926ef375e672f05ea804aacbe7d0900d203cc8716880ccf5a1df";
  hash = "sha256-zz2a5q5BsZwf7gEkjhKhLwGaAEj5+uN7ECex4OUowqw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
