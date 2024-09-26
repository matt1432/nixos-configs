pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:8d3da3256868cf40f06cdca2074dee07a190ec42a6df022fb9fe6f73842ba293";
  sha256 = "17j28lq4ndsmn04xx2151ngx8jfajhihrla8rjflak5psjmzrclg";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
