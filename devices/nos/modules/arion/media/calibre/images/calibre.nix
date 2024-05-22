pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:7d19a20a9e4f5e7f6d5fac9baf7f60944554904de46a5bef3d0d6cf2c5118bf4";
  sha256 = "1xf4bgfg9qsdqnr4mxgshv0m9g1c4a49i9nkmnfciwna6nf8qrh4";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
