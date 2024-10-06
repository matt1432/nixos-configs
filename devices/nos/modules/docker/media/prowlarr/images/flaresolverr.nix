pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "21hsmw/flaresolverr";
  imageDigest = "sha256:14447de91cff69e78059864e6540d42a5b94a8ec1b1856485cd015afbab91b9c";
  sha256 = "16s1zalnznsj8w2h2rdjpll9zqgiy2iqs79d2znxn8cm6qvd8zb3";
  finalImageName = imageName;
  finalImageTag = "nodriver";
}
