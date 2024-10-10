pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:d7d431c29d1c94e7009b6b8b1eb5078689416278b5e6664cad864b28b9ead345";
  sha256 = "0j5yblqqljv7rcvfk2a9m4xlng3gq3amc740xljhmsac1wlsn0r1";
  finalImageName = imageName;
  finalImageTag = "latest";
}
