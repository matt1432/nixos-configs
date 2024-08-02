pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:e179e32b1ed42814816e5379d08ee9d9f957f6e704c8695bd1ffece9668a9192";
  sha256 = "13n3rw7w6a6nkq578qjhypkwh2xm7a79lmi57klzx1gsxddp5r04";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
