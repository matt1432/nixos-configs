pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:15e7464dd1a2997d9398b1f2161c7e8fff8518cf71c1b20b8fb1b5e354b31ece";
  sha256 = "126b5965hcsjxa8y9qy0zgvdfma6yrhlb4yws6sil1h05n67g2s9";
  finalImageName = "ghcr.io/fallenbagel/jellyseerr";
  finalImageTag = "develop";
}
