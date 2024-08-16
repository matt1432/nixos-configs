pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:95179d6de1c660d7dcd4bd3991b33871c88df1120ab84bc553c4a67e8cc412d2";
  sha256 = "0sfschwh2dsl0pr7ns72azfa1qacmj4zv22jawkl3r4bcljdmay8";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
