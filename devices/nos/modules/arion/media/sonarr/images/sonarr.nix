pkgs:
pkgs.dockerTools.pullImage {
  imageName = "lscr.io/linuxserver/sonarr";
  imageDigest = "sha256:29fc87e914b8e288651271e2ba304bbdf2b2e7d2b3cbe700345c997d0e90a821";
  sha256 = "1rhw9ymbw8mdrfs5w8pdnd7wnlnw79ajb5wrzbxsrq57wvqk1ns6";
  finalImageName = "lscr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
