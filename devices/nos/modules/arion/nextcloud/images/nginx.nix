pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:6db391d1c0cfb30588ba0bf72ea999404f2764febf0f1f196acd5867ac7efa7e";
  sha256 = "0mhc4872dw11x8378mwqbvbwylwaxly8qj3vj121bf7qjln4ad6a";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
