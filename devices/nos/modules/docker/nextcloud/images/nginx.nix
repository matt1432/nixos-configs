pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:b5d3f3e104699f0768e5ca8626914c16e52647943c65274d8a9e63072bd015bb";
  sha256 = "1h8spb26v4i20zpzrpwxsdnavws8bg6id1rq2ngd0f5j3sg9pxc8";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
