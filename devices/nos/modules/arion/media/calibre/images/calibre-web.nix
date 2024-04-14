pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre-web";
  imageDigest = "sha256:91de784bd006562b2929df9dff56d8d42a4beafc4eef6d5a7cdc6e84c268c4be";
  sha256 = "0zpn4xmka841c3d897wykym4vf47rm07cdvwi18irylxrqsdfmgr";
  finalImageName = "ghcr.io/linuxserver/calibre-web";
  finalImageTag = "latest";
}
