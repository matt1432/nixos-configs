pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:0f04e4f646a3f14bf31d8bc8d885b6c951fdcf42589d06845f64d18aec6a3c4d";
  sha256 = "159z86nw6riirs9ix4zix7qawhfngl5fkx7ypmi6ib0sfayc8pw2";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
