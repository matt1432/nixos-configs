pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:c516ac417cc045bbeb1738c6ddc9ea0faa5dee101758a4147836c11f76da3e09";
  sha256 = "09d90slkahbdi368dwpsjpkaqq5yzx5hyv6p27mz9hv9q6w3j64z";
  finalImageName = "postgres";
  finalImageTag = "14";
}
