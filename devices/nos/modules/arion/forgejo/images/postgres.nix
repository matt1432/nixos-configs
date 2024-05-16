pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:da8b991e3909fc95a272fcbeb1e0d79ce1a7028fe1549b1ba0ed0a6a45e126cb";
  sha256 = "1mkskwa4s7j86qj42b7sgdjp9s3c838i3i5lmba0l69pdmgygs3m";
  finalImageName = "postgres";
  finalImageTag = "14";
}
