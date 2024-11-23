pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:1bd04442a6cb35fc8f4a18c474ba93d6600026dcbd364d0577e63cc6cdebfd87";
  sha256 = "0ijrfxhyvjzr2q6yv0f8ik9sb3nak2zqw1pk0fxrmhl1baf61bc2";
  finalImageName = imageName;
  finalImageTag = "latest";
}
