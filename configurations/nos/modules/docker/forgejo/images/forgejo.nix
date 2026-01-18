pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:d05b9e587f02a746784d42c815c486b1d4f138646128f990a841833f513fe088";
  hash = "sha256-3q7bw345lAEbhboCM7BF1yYMFv9CaR77wKNiCcNIwuA=";
  finalImageName = imageName;
  finalImageTag = "13";
}
