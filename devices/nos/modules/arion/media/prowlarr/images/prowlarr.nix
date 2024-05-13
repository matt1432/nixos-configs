pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:b0dabccc49b6e994665ae8751224aa3ca4c31b29b18815394a330d591e5f8ed8";
  sha256 = "07kj2v014niakjb52vxjzkp99zd48yh6hxwlbbn3s858wy12kgmv";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
