pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:fa53a6b85d34abb46593b3959223b5b4eb9d97c067ce4ad0bdb9c552e1906d17";
  sha256 = "14yrk7k03vminxmc3va7xpnzy5y9vy3845pppq20z8yggpd6yvxr";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
