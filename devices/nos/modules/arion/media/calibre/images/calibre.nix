pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:4a1f1f9adcee133b374dc9ea783b6b735844313f99c65fb62cb15cc0089d1948";
  sha256 = "0wffb24wirkkf43zalif72f155byccqmsgna7rrjln25jpdpnz5a";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
