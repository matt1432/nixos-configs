pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:5b8d05994df326db82f744469e4321d1b9f4feb52f5d217c06ad384d5c8377e2";
  sha256 = "192f86wa3z8khr7fh7cnd1nin5ilmp3bhw5faygnv9fh58ywipmn";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
