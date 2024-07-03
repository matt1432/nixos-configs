pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:211cfc5b99e14dee7d49190b6ac8cceee3183a58240d522fb1937847ee4518e4";
  sha256 = "0i9kd2syyq2y91aw8d6d8q6a44811a498bl25m1h3cx3j25m4vd4";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
