pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:148b383bf37b569f1b44d72b3558979540e9f5f951789b0b0c6e827decbeef09";
  sha256 = "10cm27yf518b3a8qf7xi6x6dbsdxlb5x9r7y9v6wn6y42zvplgym";
  finalImageName = "postgres";
  finalImageTag = "14";
}
