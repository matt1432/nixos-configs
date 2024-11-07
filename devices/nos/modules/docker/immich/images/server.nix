pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:ac215f5c1a52f7b25617924db61d54bb72b534d902ccb58eb595cdba98899aa3";
  sha256 = "11zr4wg3wn1rhi6ix2c312f7pn6d1a6ic7930pwvaq8anylpch1i";
  finalImageName = imageName;
  finalImageTag = "release";
}
