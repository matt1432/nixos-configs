pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:576b61b488e3bd2cd0d56cd080189ebb60eb12f35280632d00f689f8e25e3524";
  sha256 = "066psqnpbaywmzymghvdwxi75hi5m5sw6lwgkwajfkx2mlc8zz7z";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
