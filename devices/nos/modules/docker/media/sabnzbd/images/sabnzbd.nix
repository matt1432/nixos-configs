pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:f87f9d4fa0e19f8e7b292638b3fa89cafc4a96d858fbda8106e3cea6343432c1";
  sha256 = "0vxk5w9yf9aray1aq13djs6yqpmd2082zjldb1m5ijfxba85iq9y";
  finalImageName = imageName;
  finalImageTag = "latest";
}
