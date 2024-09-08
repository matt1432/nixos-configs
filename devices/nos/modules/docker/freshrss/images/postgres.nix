pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:1bd26d434ac67d210a42cf19fa0812efd22472e0494f9c6ffa654509f427608a";
  sha256 = "10cm27yf518b3a8qf7xi6x6dbsdxlb5x9r7y9v6wn6y42zvplgym";
  finalImageName = "postgres";
  finalImageTag = "14";
}
