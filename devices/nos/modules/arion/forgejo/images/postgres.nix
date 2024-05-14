pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:73602f0cdabd8c8805d53b6f6a698f4fab5000896aae05549d71d7e7e8b6110d";
  sha256 = "1mkskwa4s7j86qj42b7sgdjp9s3c838i3i5lmba0l69pdmgygs3m";
  finalImageName = "postgres";
  finalImageTag = "14";
}
