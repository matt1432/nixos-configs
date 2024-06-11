pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:dbd97b5111d8655df32f8874d249b243ac1d4375649a2868bcc8e6a0f05aa09d";
  sha256 = "04d1kz9qm3j4mnz5ixzm2mkj84cf6bx8rlw8iszp1sk5mwyncwci";
  finalImageName = "ghcr.io/fallenbagel/jellyseerr";
  finalImageTag = "develop";
}
