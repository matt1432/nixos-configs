pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:0215b55fb7ebb552fc4a42c5110deedc0d3968ef60a40942fd323d7744f8076a";
  sha256 = "0xympyl54yccri1qsir7k3fq9cx05nh9770jxiilmxjyp7lpfnhc";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
