pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:6a8db539588665971f24a42e31ddf2240d7be114c08007dc409aff7638c8edf6";
  sha256 = "1j8jas2bkp23il9g1k2vklnkzs9x8fxwgjpdd8w7l4kxbld50zaa";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
