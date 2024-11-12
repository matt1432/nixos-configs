pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:5026c85d87419b6c3622622570ea5c25ab9f9bb48961554658272bbc18e518b1";
  sha256 = "0zas3xrxlrr1qd3hc5p63q5hpja3cdfvv6alx10j8q489wn21m0s";
  finalImageName = imageName;
  finalImageTag = "latest";
}
