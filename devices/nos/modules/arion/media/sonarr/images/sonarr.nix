pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:f11f32d67bb7ef20333e22546b04a244e4e8172cb9744b026381cf898a1f2ece";
  sha256 = "02mlalvi577ggb9ia2wggxnm8kwz92dsh9v98qq3y0zpsizyr4gn";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
