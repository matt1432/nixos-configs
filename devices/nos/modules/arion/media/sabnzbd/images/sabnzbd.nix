pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:0c3a6644a21fc365c5a3ef44525e961e458f862e74852bf1828d35f478463566";
  sha256 = "1qxv8vg65ix4yiiwq9y0bxn9s3spd95vbj6slaw5rd1qrj1sn6zn";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
