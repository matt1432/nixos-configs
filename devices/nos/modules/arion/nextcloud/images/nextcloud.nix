pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:38ffb1b0d3958af3f2fb78df5977a1c23e0a24aca4fc288b71e8ee4b63257904";
  sha256 = "01z1j9s1xx2l61ychmb2qc5sx88hsnsjh7xcbb9y507g7l2m316i";
  finalImageName = "nextcloud";
  finalImageTag = "fpm";
}
