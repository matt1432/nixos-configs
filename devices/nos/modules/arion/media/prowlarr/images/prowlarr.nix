pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:68c1cd92049e290e37688b8d9b50d0a2c76fb3c5c3b96c0b1300312caa0e6265";
  sha256 = "1mjlyjqqkcv26xlv9y6ysimgcnb2mpvd142870qnia7x7xj5pbsg";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
