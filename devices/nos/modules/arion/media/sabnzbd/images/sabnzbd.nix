pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:d9ad6d86542e07d90e6da20b2adb9e89cb26ec1dc1d95bd88eeceef65c12f94b";
  sha256 = "0lanxhy7c5kj4a1zfbw6p5pn44nm9q0bkqm1pmnq64qsk7wpi1gm";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
