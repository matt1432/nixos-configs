pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:70be7cdb6eb010e9101e83e2731b2c4859ddcfd682049b80a7ba73508d948c1e";
  sha256 = "1cg4zcbnpkx2fwp7dsawmddf8vxqmsw010s8zbgipa3camdwrmsy";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
